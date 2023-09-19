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

package org.apache.shenyu.springboot.starter.client.spring.websocket;

import org.apache.shenyu.client.core.constant.ShenyuClientConstants;
import org.apache.shenyu.client.core.register.InstanceRegisterListener;
import org.apache.shenyu.client.spring.websocket.init.SpringWebSocketClientEventListener;
import org.apache.shenyu.common.dto.DiscoveryUpstreamData;
import org.apache.shenyu.common.enums.RpcTypeEnum;
import org.apache.shenyu.common.utils.VersionUtils;
import org.apache.shenyu.register.client.api.ShenyuClientRegisterRepository;
import org.apache.shenyu.register.common.config.ShenyuClientConfig;
import org.apache.shenyu.register.common.config.ShenyuDiscoveryConfig;
import org.apache.shenyu.springboot.starter.client.common.config.ShenyuClientCommonBeanConfiguration;
import org.springframework.boot.autoconfigure.ImportAutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnBean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * The type shenyu websocket client http configuration.
 */
@Configuration
@ImportAutoConfiguration(ShenyuClientCommonBeanConfiguration.class)
@ConditionalOnProperty(value = "shenyu.register.enabled", matchIfMissing = true, havingValue = "true")
public class ShenyuSpringWebSocketClientConfiguration {

    static {
        VersionUtils.checkDuplicate(ShenyuSpringWebSocketClientConfiguration.class);
    }

    /**
     * Spring web socket client event listener.
     *
     * @param clientConfig                   the client config
     * @param shenyuClientRegisterRepository the shenyu client register repository
     * @return the spring web socket client event listener
     */
    @Bean
    public SpringWebSocketClientEventListener springWebSocketClientEventListener(
            final ShenyuClientConfig clientConfig,
            final ShenyuClientRegisterRepository shenyuClientRegisterRepository) {
        return new SpringWebSocketClientEventListener(clientConfig.getClient().get(RpcTypeEnum.WEB_SOCKET.getName()), shenyuClientRegisterRepository);
    }

    /**
     * InstanceRegisterListener.
     *
     * @param eventListener         eventListener
     * @param shenyuDiscoveryConfig discoveryConfig
     * @return InstanceRegisterListener
     */
    @Bean
    @ConditionalOnBean(ShenyuDiscoveryConfig.class)
    public InstanceRegisterListener instanceRegisterListener(final SpringWebSocketClientEventListener eventListener, final ShenyuDiscoveryConfig shenyuDiscoveryConfig) {
        DiscoveryUpstreamData discoveryUpstreamData = new DiscoveryUpstreamData();
        discoveryUpstreamData.setProtocol(ShenyuClientConstants.WS);
        discoveryUpstreamData.setStatus(0);
        discoveryUpstreamData.setWeight(Integer.parseInt(shenyuDiscoveryConfig.getWeight()));
        discoveryUpstreamData.setUrl(eventListener.getHost() + ":" + eventListener.getPort());
        return new InstanceRegisterListener(discoveryUpstreamData, shenyuDiscoveryConfig);
    }
}
