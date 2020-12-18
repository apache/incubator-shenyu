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

package org.dromara.soul.plugin.monitor;

import org.dromara.soul.common.dto.RuleData;
import org.dromara.soul.common.dto.SelectorData;
import org.dromara.soul.common.enums.PluginEnum;
import org.dromara.soul.plugin.api.SoulPluginChain;
import org.junit.Before;
import org.junit.Test;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;
import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Test case for MonitorPlugin.
 *
 * @author wincher
 */
public final class MonitorPluginTest {

    private MonitorPlugin monitorPlugin;

    @Before
    public void setup() {
        monitorPlugin = new MonitorPlugin();
    }

    @Test
    public void testDoExecute() {
        final ServerWebExchange exchange = MockServerWebExchange.from(MockServerHttpRequest.get("localhost").build());
        SoulPluginChain chain = mock(SoulPluginChain.class);
        when(chain.execute(exchange)).thenReturn(Mono.empty());
        SelectorData selectorData = mock(SelectorData.class);
        RuleData data = mock(RuleData.class);
        Mono<Void> voidMono = monitorPlugin.doExecute(exchange, chain, selectorData, data);
        StepVerifier.create(voidMono).expectSubscription().verifyComplete();
    }

    @Test
    public void testGetOrder() {
        assertEquals(PluginEnum.MONITOR.getCode(), monitorPlugin.getOrder());
    }

    @Test
    public void testNamed() {
        assertEquals(PluginEnum.MONITOR.getName(), monitorPlugin.named());
    }
}
