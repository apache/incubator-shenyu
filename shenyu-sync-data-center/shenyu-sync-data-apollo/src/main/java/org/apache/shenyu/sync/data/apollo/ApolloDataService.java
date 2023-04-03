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

package org.apache.shenyu.sync.data.apollo;

import com.ctrip.framework.apollo.Config;
import com.ctrip.framework.apollo.ConfigChangeListener;
import org.apache.shenyu.common.constant.DefaultPathConstants;
import org.apache.shenyu.common.constant.ApolloPathConstants;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.AppAuthData;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.sync.data.api.AuthDataSubscriber;
import org.apache.shenyu.sync.data.api.MetaDataSubscriber;
import org.apache.shenyu.sync.data.api.PluginDataSubscriber;
import org.apache.shenyu.sync.data.api.SyncDataService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Collection;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

public class ApolloDataService implements SyncDataService {

    /**
     * logger.
     */
    private static final Logger LOG = LoggerFactory.getLogger(ApolloDataService.class);

    private final Config configService;

    private final PluginDataSubscriber pluginDataSubscriber;

    private final List<MetaDataSubscriber> metaDataSubscribers;

    private final List<AuthDataSubscriber> authDataSubscribers;

    private final Map<String, ConfigChangeListener> cache = new ConcurrentHashMap<>();

    /**
     * Instantiates a new Apollo data service.
     *
     * @param configService the config service
     * @param pluginDataSubscriber the plugin data subscriber
     * @param metaDataSubscribers the meta data subscribers
     * @param authDataSubscribers the auth data subscribers
     */
    public ApolloDataService(final Config configService, final PluginDataSubscriber pluginDataSubscriber,
                             final List<MetaDataSubscriber> metaDataSubscribers,
                             final List<AuthDataSubscriber> authDataSubscribers) {
        this.configService = configService;
        this.pluginDataSubscriber = pluginDataSubscriber;
        this.metaDataSubscribers = metaDataSubscribers;
        this.authDataSubscribers = authDataSubscribers;
        watch();

    }

    /**
     * watch data.
     */
    public void watch() {
        watchPluginData();
        watchSelectorData();
        watchRuleData();
        watchAuthData();
        watchMetaData();
    }

    /**
     * watch plugin data.
     */
    private void watchPluginData() {
        ConfigChangeListener configChangeListener = changeEvent -> {
            changeEvent.changedKeys().forEach(key -> {
                if (key.contains(ApolloPathConstants.PLUGIN_DATA_ID)) {
                    List<PluginData> pluginDataList = new ArrayList<>(GsonUtils.getInstance().toObjectMap(configService.getProperty(key, ""), PluginData.class).values());
                    pluginDataList.forEach(pluginData -> Optional.ofNullable(pluginDataSubscriber).ifPresent(subscriber -> {
                        LOG.info("apollo listener pluginData: {}", pluginDataList);
                        subscriber.unSubscribe(pluginData);
                        subscriber.onSubscribe(pluginData);
                    }));
                }

            });
        };
        cache.put(DefaultPathConstants.PLUGIN_PARENT, configChangeListener);
        configService.addChangeListener(configChangeListener);
    }

    /**
     * watch selector data.
     */
    private void watchSelectorData() {
        ConfigChangeListener configChangeListener = changeEvent -> {
            changeEvent.changedKeys().forEach(key -> {
                if (key.contains(ApolloPathConstants.SELECTOR_DATA_ID)) {
                    List<SelectorData> selectorDataList = GsonUtils.getInstance().toObjectMapList(configService.getProperty(key, ""), SelectorData.class)
                            .values().stream().flatMap(Collection::stream).collect(Collectors.toList());
                    selectorDataList.forEach(selectorData -> Optional.ofNullable(pluginDataSubscriber).ifPresent(subscriber -> {
                        LOG.info("apollo listener selectorData: {}", selectorDataList);
                        subscriber.unSelectorSubscribe(selectorData);
                        subscriber.onSelectorSubscribe(selectorData);
                    }));
                }

            });
        };
        cache.put(DefaultPathConstants.SELECTOR_PARENT, configChangeListener);
        configService.addChangeListener(configChangeListener);
    }

    /**
     * watch rule data.
     */
    private void watchRuleData() {
        ConfigChangeListener configChangeListener = changeEvent -> {
            changeEvent.changedKeys().forEach(key -> {
                if (key.contains(ApolloPathConstants.RULE_DATA_ID)) {
                    List<RuleData> ruleDataList = GsonUtils.getInstance().toObjectMapList(configService.getProperty(key, ""), RuleData.class).values()
                            .stream().flatMap(Collection::stream)
                            .collect(Collectors.toList());
                    ruleDataList.forEach(ruleData -> Optional.ofNullable(pluginDataSubscriber).ifPresent(subscriber -> {
                        LOG.info("apollo listener ruleData: {}", ruleDataList);
                        subscriber.unRuleSubscribe(ruleData);
                        subscriber.onRuleSubscribe(ruleData);
                    }));
                }

            });
        };
        cache.put(ApolloPathConstants.RULE_DATA_ID, configChangeListener);
        configService.addChangeListener(configChangeListener);
    }

    /**
     * watch meta data.
     */
    private void watchMetaData() {
        ConfigChangeListener configChangeListener = changeEvent -> {
            changeEvent.changedKeys().forEach(key -> {
                if (key.contains(ApolloPathConstants.META_DATA_ID)) {
                    List<MetaData> metaDataList = new ArrayList<>(GsonUtils.getInstance().toObjectMap(configService.getProperty(key, ""), MetaData.class).values());
                    metaDataList.forEach(metaData -> metaDataSubscribers.forEach(subscriber -> {
                        LOG.info("apollo listener metaData: {}", metaDataList);
                        subscriber.unSubscribe(metaData);
                        subscriber.onSubscribe(metaData);
                    }));
                }

            });
        };
        cache.put(ApolloPathConstants.META_DATA_ID, configChangeListener);
        configService.addChangeListener(configChangeListener);
    }

    /**
     * watch auth data.
     */
    private void watchAuthData() {
        ConfigChangeListener configChangeListener = changeEvent -> {
            changeEvent.changedKeys().forEach(key -> {
                if (key.contains(ApolloPathConstants.AUTH_DATA_ID)) {
                    List<AppAuthData> appAuthDataList = new ArrayList<>(GsonUtils.getInstance().toObjectMap(configService.getProperty(key, ""), AppAuthData.class).values());
                    appAuthDataList.forEach(appAuthData -> authDataSubscribers.forEach(subscriber -> {
                        LOG.info("apollo listener appAuthData: {}", appAuthDataList);
                        subscriber.unSubscribe(appAuthData);
                        subscriber.onSubscribe(appAuthData);
                    }));
                }

            });
        };
        cache.put(ApolloPathConstants.AUTH_DATA_ID, configChangeListener);
        configService.addChangeListener(configChangeListener);
    }

    @Override
    public void close() {
        configService.removeChangeListener(cache.get(ApolloPathConstants.PLUGIN_DATA_ID));
        configService.removeChangeListener(cache.get(ApolloPathConstants.SELECTOR_DATA_ID));
        configService.removeChangeListener(cache.get(ApolloPathConstants.RULE_DATA_ID));
        configService.removeChangeListener(cache.get(ApolloPathConstants.AUTH_DATA_ID));
        configService.removeChangeListener(cache.get(ApolloPathConstants.META_DATA_ID));
        cache.clear();
    }
}
