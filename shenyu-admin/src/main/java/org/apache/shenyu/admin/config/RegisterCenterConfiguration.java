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

package org.apache.shenyu.admin.config;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.disruptor.RegisterClientServerDisruptorPublisher;
import org.apache.shenyu.admin.lock.RegisterExecutionRepository;
import org.apache.shenyu.admin.lock.impl.PlatformTransactionRegisterExecutionRepository;
import org.apache.shenyu.admin.mapper.PluginMapper;
import org.apache.shenyu.admin.register.client.server.api.ShenyuClientServerRegisterRepository;
import org.apache.shenyu.admin.service.register.ShenyuClientRegisterService;
import org.apache.shenyu.common.utils.IpUtils;
import org.apache.shenyu.register.common.config.ShenyuRegisterCenterConfig;
import org.apache.shenyu.spi.ExtensionLoader;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.jdbc.lock.DefaultLockRepository;
import org.springframework.integration.jdbc.lock.JdbcLockRegistry;
import org.springframework.integration.jdbc.lock.LockRepository;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

/**
 * The type Register center configuration.
 */
@Configuration
public class RegisterCenterConfiguration {
    
    @Value("${server.servlet.context-path:}")
    private String contextPath;
    
    @Value("${server.port:}")
    private String port;

    /**
     * Shenyu register center config shenyu register center config.
     *
     * @return the shenyu register center config
     */
    @Bean
    @ConfigurationProperties(prefix = "shenyu.register")
    public ShenyuRegisterCenterConfig shenyuRegisterCenterConfig() {
        return new ShenyuRegisterCenterConfig();
    }

    /**
     * Shenyu client server register repository server register repository.
     *
     * @param shenyuRegisterCenterConfig the shenyu register center config
     * @param shenyuClientRegisterService the shenyu client register service
     * @return the shenyu server register repository
     */
    @Bean(destroyMethod = "close")
    public ShenyuClientServerRegisterRepository shenyuClientServerRegisterRepository(final ShenyuRegisterCenterConfig shenyuRegisterCenterConfig,
                                                                               final List<ShenyuClientRegisterService> shenyuClientRegisterService) {
        String registerType = shenyuRegisterCenterConfig.getRegisterType();
        ShenyuClientServerRegisterRepository registerRepository = ExtensionLoader.getExtensionLoader(ShenyuClientServerRegisterRepository.class).getJoin(registerType);
        RegisterClientServerDisruptorPublisher publisher = RegisterClientServerDisruptorPublisher.getInstance();
        Map<String, ShenyuClientRegisterService> registerServiceMap = shenyuClientRegisterService.stream().collect(Collectors.toMap(ShenyuClientRegisterService::rpcType, Function.identity()));
        publisher.start(registerServiceMap);
        registerRepository.init(publisher, shenyuRegisterCenterConfig);
        return registerRepository;
    }

    /**
     * Shenyu client server register  server global lock repository.
     *
     * @param platformTransactionManager the platformTransactionManager
     * @param pluginMapper the shenyu pluginMapper
     * @return the shenyu server register repository
     */
    @Bean
    @ConditionalOnMissingBean(name = "registerExecutionRepository")
    public RegisterExecutionRepository registerExecutionRepository(final PlatformTransactionManager platformTransactionManager, final PluginMapper pluginMapper) {
        return new PlatformTransactionRegisterExecutionRepository(platformTransactionManager, pluginMapper);
    }


    /**
     * Shenyu Admin distributed lock by spring-integration-jdbc.
     *
     * @param dataSource the dataSource
     * @return  defaultLockRepository
     */
    @Bean
    @ConfigurationProperties(prefix = "shenyu.distributed-lock")
    public DefaultLockRepository defaultLockRepository(final DataSource dataSource) {
        final String host = IpUtils.getHost();
        String fullPath = host + ":" + port;
        if (StringUtils.isNoneBlank(contextPath)) {
            fullPath += contextPath;
        }
        DefaultLockRepository defaultLockRepository = new DefaultLockRepository(dataSource, fullPath);
        defaultLockRepository.setPrefix("SHENYU_");
        return defaultLockRepository;
    }

    /**
     * Shenyu Admin distributed lock by spring-integration-jdbc.
     *
     * @param lockRepository the lockRepository
     * @return the shenyu Admin register repository
     */
    @Bean
    public JdbcLockRegistry jdbcLockRegistry(final LockRepository lockRepository) {
        return new JdbcLockRegistry(lockRepository);
    }
}
