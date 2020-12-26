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

package org.dromara.soul.web.forward;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import org.springframework.web.server.ServerWebExchange;

import java.lang.reflect.Field;

/**
 * Test cases for ForwardedRemoteAddressResolver.
 *
 * @author xiaoshen11
 */
@RunWith(MockitoJUnitRunner.class)
public final class ForwardedRemoteAddressResolverTest {

    @Test
    public void testNewInstance() throws Exception {
        try {
            ForwardedRemoteAddressResolver.maxTrustedIndex(0);
        } catch (Exception e) {
            Assert.assertEquals(e.getMessage(), "An index greater than 0 is required");
        }

        ForwardedRemoteAddressResolver instance = ForwardedRemoteAddressResolver.maxTrustedIndex(5);
        Class<?> instanceClass = instance.getClass();
        Field field = instanceClass.getDeclaredField("maxTrustedIndex");
        field.setAccessible(true);
        int maxTrustedIndex = (int) field.get(instance);
        Assert.assertEquals(maxTrustedIndex, 5);

        ForwardedRemoteAddressResolver all = ForwardedRemoteAddressResolver.trustAll();
        maxTrustedIndex = (int) field.get(all);
        Assert.assertEquals(maxTrustedIndex, Integer.MAX_VALUE);
    }

    @Test
    public void testResolver() {
        ForwardedRemoteAddressResolver instance = ForwardedRemoteAddressResolver.maxTrustedIndex(1);
        final ServerWebExchange exchange = MockServerWebExchange.from(MockServerHttpRequest.post("localhost")
                .build());
        final ServerWebExchange emptyForwardExchange = MockServerWebExchange.from(MockServerHttpRequest.post("localhost")
                .header("X-Forwarded-For", "")
                .build());
        final ServerWebExchange forwardExchange = MockServerWebExchange.from(MockServerHttpRequest.post("localhost")
                .header("X-Forwarded-For", "127.0.0.1")
                .build());
        final ServerWebExchange multiForwardExchangeError = MockServerWebExchange.from(MockServerHttpRequest.post("localhost")
                .header("X-Forwarded-For", "127.0.0.1", "127.0.0.2")
                .build());
        final ServerWebExchange multiForwardExchange = MockServerWebExchange.from(MockServerHttpRequest.post("localhost")
                .header("X-Forwarded-For", "127.0.0.1, 127.0.0.2")
                .build());

        instance.resolve(exchange);
        instance.resolve(emptyForwardExchange);
        instance.resolve(forwardExchange);
        instance.resolve(multiForwardExchangeError);
        instance.resolve(multiForwardExchange);
    }

}
