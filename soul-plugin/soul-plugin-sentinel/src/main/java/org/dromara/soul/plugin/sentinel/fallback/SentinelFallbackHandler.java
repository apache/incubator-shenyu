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

package org.dromara.soul.plugin.sentinel.fallback;

import com.alibaba.csp.sentinel.slots.block.BlockException;
import com.alibaba.csp.sentinel.slots.block.degrade.DegradeException;
import com.alibaba.csp.sentinel.slots.block.flow.FlowException;
import org.dromara.soul.plugin.api.result.SoulResultEnum;
import org.dromara.soul.plugin.base.fallback.FallbackHandler;
import org.dromara.soul.plugin.base.utils.SoulResultWrap;
import org.dromara.soul.plugin.base.utils.WebFluxResultUtils;
import org.dromara.soul.plugin.sentinel.SentinelPlugin;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Sentinel block handler.
 *
 * @author zhanglei
 */
public class SentinelFallbackHandler implements FallbackHandler {

    @Override
    public Mono<Void> generateError(final ServerWebExchange exchange, final Throwable throwable) {
        Object error;
        if (throwable instanceof SentinelPlugin.SentinelFallbackException) {
            return Mono.error(throwable);
        } else if (throwable instanceof DegradeException) {
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            error = SoulResultWrap.error(SoulResultEnum.SERVICE_RESULT_ERROR.getCode(), SoulResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
        } else if (throwable instanceof FlowException) {
            exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
            error = SoulResultWrap.error(SoulResultEnum.TOO_MANY_REQUESTS.getCode(), SoulResultEnum.TOO_MANY_REQUESTS.getMsg(), null);
        } else if (throwable instanceof BlockException) {
            exchange.getResponse().setStatusCode(HttpStatus.TOO_MANY_REQUESTS);
            error = SoulResultWrap.error(SoulResultEnum.SENTINEL_BLOCK_ERROR.getCode(), SoulResultEnum.SENTINEL_BLOCK_ERROR.getMsg(), null);
        } else {
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            error = SoulResultWrap.error(SoulResultEnum.SERVICE_RESULT_ERROR.getCode(), SoulResultEnum.SERVICE_RESULT_ERROR.getMsg(), null);
        }
        return WebFluxResultUtils.result(exchange, error);
    }
}
