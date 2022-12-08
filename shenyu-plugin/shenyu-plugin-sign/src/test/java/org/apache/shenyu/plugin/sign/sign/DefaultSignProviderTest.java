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

package org.apache.shenyu.plugin.sign.sign;

import org.apache.shenyu.plugin.api.utils.SpringBeanUtils;
import org.apache.shenyu.plugin.sign.api.DefaultSignProvider;
import org.apache.shenyu.plugin.sign.api.ShenyuSignProviderWrap;
import org.apache.shenyu.plugin.sign.api.SignProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ConfigurableApplicationContext;

import java.util.HashMap;
import java.util.Map;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * The Shenyu default sign provider test.
 */
@ExtendWith(MockitoExtension.class)
public class DefaultSignProviderTest {

    @BeforeEach
    public void setUp() {
        ConfigurableApplicationContext context = mock(ConfigurableApplicationContext.class);
        SpringBeanUtils.getInstance().setApplicationContext(context);
        when(context.getBean(SignProvider.class)).thenReturn(new DefaultSignProvider());
    }

    @Test
    public void testGenerateSign() {
        Map<String, String> jsonParams = new HashMap<>();
        jsonParams.put("a", "1");
        jsonParams.put("b", "2");
        Map<String, String> queryParams = new HashMap<>();
        queryParams.put("a", "1");
        queryParams.put("b", "2");
        assertThat(ShenyuSignProviderWrap.generateSign("test", jsonParams, queryParams),
                is("9DDBB668873D97C25904FD9D5D6314CD"));
    }
}
