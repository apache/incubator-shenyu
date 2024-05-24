/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.shenyu.plugin.sync.data.websocket;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Lists;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.timer.AbstractRoundTask;
import org.apache.shenyu.common.timer.Timer;
import org.apache.shenyu.common.timer.TimerTask;
import org.apache.shenyu.common.timer.WheelTimerFactory;
import org.apache.shenyu.plugin.sync.data.websocket.client.ShenyuClusterWebsocketClient;
import org.apache.shenyu.plugin.sync.data.websocket.client.ShenyuWebsocketClient;
import org.apache.shenyu.plugin.sync.data.websocket.config.WebsocketConfig;
import org.apache.shenyu.sync.data.api.AuthDataSubscriber;
import org.apache.shenyu.sync.data.api.DiscoveryUpstreamDataSubscriber;
import org.apache.shenyu.sync.data.api.MetaDataSubscriber;
import org.apache.shenyu.sync.data.api.PluginDataSubscriber;
import org.apache.shenyu.sync.data.api.ProxySelectorDataSubscriber;
import org.apache.shenyu.sync.data.api.SyncDataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * Websocket sync data service.
 */
public class WebsocketSyncDataService implements SyncDataService {
    
    /**
     * logger.
     */
    private static final Logger LOG = LoggerFactory.getLogger(WebsocketSyncDataService.class);
    
    /**
     * see https://github.com/apache/tomcat/blob/main/java/org/apache/tomcat/websocket/Constants.java#L99.
     */
    private static final String ORIGIN_HEADER_NAME = "Origin";
    
    private ShenyuWebsocketClient client;
    
    private final WebsocketConfig websocketConfig;
    
    private final PluginDataSubscriber pluginDataSubscriber;
    
    private final List<MetaDataSubscriber> metaDataSubscribers;
    
    private final List<AuthDataSubscriber> authDataSubscribers;
    
    private final List<ProxySelectorDataSubscriber> proxySelectorDataSubscribers;
    
    private final List<DiscoveryUpstreamDataSubscriber> discoveryUpstreamDataSubscribers;
    
    private final List<ShenyuClusterWebsocketClient> clusterClients = Lists.newArrayList();
    
    private final List<ShenyuWebsocketClient> clients = Lists.newArrayList();
    
    private final Timer timer;
    
    private TimerTask timerTask;
    
    /**
     * Instantiates a new Websocket sync cache.
     *
     * @param websocketConfig the websocket config
     * @param pluginDataSubscriber the plugin data subscriber
     * @param metaDataSubscribers the meta data subscribers
     * @param authDataSubscribers the auth data subscribers
     */
    public WebsocketSyncDataService(final WebsocketConfig websocketConfig,
                                    final PluginDataSubscriber pluginDataSubscriber,
                                    final List<MetaDataSubscriber> metaDataSubscribers,
                                    final List<AuthDataSubscriber> authDataSubscribers,
                                    final List<ProxySelectorDataSubscriber> proxySelectorDataSubscribers,
                                    final List<DiscoveryUpstreamDataSubscriber> discoveryUpstreamDataSubscribers
    ) {
        this.timer = WheelTimerFactory.getSharedTimer();
        this.websocketConfig = websocketConfig;
        this.pluginDataSubscriber = pluginDataSubscriber;
        this.metaDataSubscribers = metaDataSubscribers;
        this.authDataSubscribers = authDataSubscribers;
        this.proxySelectorDataSubscribers = proxySelectorDataSubscribers;
        this.discoveryUpstreamDataSubscribers = discoveryUpstreamDataSubscribers;
        
        List<String> urls = websocketConfig.getUrls();
        try {
            for (String url : urls) {
                if (StringUtils.isNotEmpty(websocketConfig.getAllowOrigin())) {
                    Map<String, String> headers = ImmutableMap.of(ORIGIN_HEADER_NAME, websocketConfig.getAllowOrigin());
                    this.clusterClients.add(new ShenyuClusterWebsocketClient(new URI(url), headers));
                } else {
                    this.clusterClients.add(new ShenyuClusterWebsocketClient(new URI(url)));
                }
                if (StringUtils.isNotEmpty(websocketConfig.getAllowOrigin())) {
                    Map<String, String> headers = ImmutableMap.of(ORIGIN_HEADER_NAME, websocketConfig.getAllowOrigin());
                    clients.add(new ShenyuWebsocketClient(new URI(url), headers, Objects.requireNonNull(pluginDataSubscriber), metaDataSubscribers,
                            authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers));
                } else {
                    clients.add(new ShenyuWebsocketClient(new URI(url), Objects.requireNonNull(pluginDataSubscriber),
                            metaDataSubscribers, authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers));
                }
            }
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
        
        String masterUrl = getMasterUrl();
        
        if (StringUtils.isBlank(masterUrl)) {
            LOG.error("get websocket master({}) is error", masterUrl);
            return;
        }
        try {
            if (StringUtils.isNotEmpty(websocketConfig.getAllowOrigin())) {
                Map<String, String> headers = ImmutableMap.of(ORIGIN_HEADER_NAME, websocketConfig.getAllowOrigin());
                client = new ShenyuWebsocketClient(new URI(masterUrl), headers, Objects.requireNonNull(pluginDataSubscriber), metaDataSubscribers,
                        authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
            } else {
                client = new ShenyuWebsocketClient(new URI(masterUrl), Objects.requireNonNull(pluginDataSubscriber),
                        metaDataSubscribers, authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
            }
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
        
        this.timer.add(timerTask = new AbstractRoundTask(null, TimeUnit.SECONDS.toMillis(30)) {
            @Override
            public void doRun(final String key, final TimerTask timerTask) {
                masterCheck();
            }
        });
    }
    
    /**
     * Get master url.
     *
     * @return master url
     */
    private String getMasterUrl() {
        List<String> urls = websocketConfig.getUrls();
        
        for (String url : urls) {
            if (StringUtils.isNotEmpty(websocketConfig.getAllowOrigin())) {
                Map<String, String> headers = ImmutableMap.of(ORIGIN_HEADER_NAME, websocketConfig.getAllowOrigin());
                this.clusterClients.add(new ShenyuClusterWebsocketClient(URI.create(url), headers));
            } else {
                this.clusterClients.add(new ShenyuClusterWebsocketClient(URI.create(url)));
            }
        }
        
        String masterUrl = "";
        
        for (ShenyuClusterWebsocketClient clusterClient : clusterClients) {
            try {
                clusterClient.connectBlocking(5, TimeUnit.SECONDS);
            } catch (InterruptedException e) {
                //                throw new RuntimeException(e);
            }
            masterUrl = clusterClient.getMasterUrl();
            if (StringUtils.isNoneBlank(masterUrl)) {
                break;
            }
        }
        
        if (StringUtils.isBlank(masterUrl)) {
            LOG.error("get websocket master({}) is error", masterUrl);
            return masterUrl;
        }
        
        // if got the master url, shutdown all clients
        for (ShenyuClusterWebsocketClient clusterClient : clusterClients) {
            clusterClient.nowClose();
        }
        clusterClients.clear();
        
        return masterUrl;
    }
    
    private void masterCheck() {
        LOG.info("master checking task...");
        String masterUrl = getMasterUrl();
        
        if (StringUtils.isBlank(masterUrl)) {
            LOG.error("get websocket master({}) is error", masterUrl);
            return;
        }
        
        LOG.info("master url:{}", masterUrl);
        
        // check if master has changed
        if (Objects.nonNull(client)
                && client.isOpen()
                && Objects.equals(client.getURI().toString(), masterUrl)) {
            return;
        }
        
        LOG.info("master url has changed previous: [{}] latest: [{}]", client.getURI().toString(), masterUrl);
        
        // close the old session and connect to the new master
        client.nowClose();
        
        if (StringUtils.isNotEmpty(websocketConfig.getAllowOrigin())) {
            Map<String, String> headers = ImmutableMap.of(ORIGIN_HEADER_NAME, websocketConfig.getAllowOrigin());
            client = new ShenyuWebsocketClient(URI.create(masterUrl), headers, Objects.requireNonNull(pluginDataSubscriber), metaDataSubscribers,
                    authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
        } else {
            client = new ShenyuWebsocketClient(URI.create(masterUrl), Objects.requireNonNull(pluginDataSubscriber),
                    metaDataSubscribers, authDataSubscribers, proxySelectorDataSubscribers, discoveryUpstreamDataSubscribers);
        }
    }
    
    @Override
    public void close() {
        if (Objects.nonNull(client)) {
            client.nowClose();
        }
        for (ShenyuClusterWebsocketClient clusterClient : clusterClients) {
            clusterClient.nowClose();
        }
        if (Objects.nonNull(timerTask)) {
            timerTask.cancel();
        }
        timer.shutdown();
    }
    
    /**
     * get websocket config.
     *
     * @return websocket config
     */
    public WebsocketConfig getWebsocketConfig() {
        return websocketConfig;
    }
    
    /**
     * get plugin data subscriber.
     *
     * @return plugin data subscriber
     */
    public PluginDataSubscriber getPluginDataSubscriber() {
        return pluginDataSubscriber;
    }
    
    /**
     * get meta data subscriber.
     *
     * @return meta data subscriber
     */
    public List<MetaDataSubscriber> getMetaDataSubscribers() {
        return metaDataSubscribers;
    }
    
    /**
     * get auth data subscriber.
     *
     * @return auth data subscriber
     */
    public List<AuthDataSubscriber> getAuthDataSubscribers() {
        return authDataSubscribers;
    }
    
    /**
     * get proxy selector data subscriber.
     *
     * @return proxy selector data subscriber
     */
    public List<ProxySelectorDataSubscriber> getProxySelectorDataSubscribers() {
        return proxySelectorDataSubscribers;
    }
    
    /**
     * get discovery upstream data subscriber.
     *
     * @return discovery upstream data subscriber
     */
    public List<DiscoveryUpstreamDataSubscriber> getDiscoveryUpstreamDataSubscribers() {
        return discoveryUpstreamDataSubscribers;
    }
    
    /**
     * get cluster websocket clients.
     *
     * @return cluster websocket clients
     */
    public List<ShenyuClusterWebsocketClient> getClusterClients() {
        return clusterClients;
    }
}
