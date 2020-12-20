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

package org.dromara.soul.client.springcloud;

import org.dromara.soul.client.common.utils.RegisterUtils;
import org.dromara.soul.client.springcloud.annotation.SoulSpringCloudClient;
import org.dromara.soul.client.springcloud.config.SoulSpringCloudConfig;
import org.dromara.soul.client.springcloud.init.SpringCloudClientBeanPostProcessor;
import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.MethodSorters;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.MockitoJUnitRunner;
import org.mockito.stubbing.Answer;
import org.springframework.core.env.Environment;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.when;

/**
 * SpringMvcClientBeanPostProcessorTest.
 *
 * @author kaitoShy
 * @author dengliming
 */
@RunWith(MockitoJUnitRunner.class)
@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public final class SpringMvcClientBeanPostProcessorTest {
    @Mock
    private static Environment env;

    private final SpringMvcClientTestBean springMvcClientTestBean = new SpringMvcClientTestBean();

    @Before
    public void init() {
        when(env.getProperty("spring.application.name")).thenReturn("spring-cloud-test");
    }

    @Test
    public void testSoulBeanProcess() {
        // config with full
        SpringCloudClientBeanPostProcessor springCloudClientBeanPostProcessor = buildSpringCloudClientBeanPostProcessor(true);
        assertEquals(springMvcClientTestBean, springCloudClientBeanPostProcessor.postProcessAfterInitialization(springMvcClientTestBean, "springMvcClientTestBean"));
    }

    @Test
    public void testNormalBeanProcess() {
        SpringCloudClientBeanPostProcessor springCloudClientBeanPostProcessor = buildSpringCloudClientBeanPostProcessor(false);
        Object normalBean = new Object();
        assertEquals(normalBean, springCloudClientBeanPostProcessor.postProcessAfterInitialization(normalBean, "normalBean"));
    }

    @Test
    public void testWithSoulClientAnnotation() {
        try (MockedStatic mocked = mockStatic(RegisterUtils.class)) {
            mocked.when(() -> RegisterUtils.doRegister(any(), any(), any()))
                    .thenAnswer((Answer<Void>) invocation -> null);
            SpringCloudClientBeanPostProcessor springCloudClientBeanPostProcessor = buildSpringCloudClientBeanPostProcessor(false);
            ReflectionTestUtils.setField(springCloudClientBeanPostProcessor, "executorService", new ThreadPoolExecutor(1,
                    1, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<>()) {
                @Override
                public void execute(final Runnable command) {
                    command.run();
                }
            });
            assertEquals(springMvcClientTestBean, springCloudClientBeanPostProcessor.postProcessAfterInitialization(springMvcClientTestBean, "normalBean"));
        }
    }

    private SpringCloudClientBeanPostProcessor buildSpringCloudClientBeanPostProcessor(final boolean full) {
        SoulSpringCloudConfig soulSpringCloudConfig = new SoulSpringCloudConfig();
        soulSpringCloudConfig.setAdminUrl("http://127.0.0.1:8080");
        soulSpringCloudConfig.setContextPath("test");
        soulSpringCloudConfig.setFull(full);
        return new SpringCloudClientBeanPostProcessor(soulSpringCloudConfig, env);
    }

    @RestController
    @RequestMapping("/order")
    @SoulSpringCloudClient(path = "/order")
    static class SpringMvcClientTestBean {
        @PostMapping("/save")
        @SoulSpringCloudClient(path = "/save")
        public String save(@RequestBody final String body) {
            return "" + body;
        }
    }
}
