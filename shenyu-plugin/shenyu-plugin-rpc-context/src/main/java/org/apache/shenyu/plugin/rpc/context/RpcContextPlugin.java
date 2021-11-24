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

package org.apache.shenyu.plugin.rpc.context;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.dto.convert.rule.RpcContextHandle;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.plugin.api.ShenyuPluginChain;
import org.apache.shenyu.plugin.base.AbstractShenyuPlugin;
import org.apache.shenyu.plugin.base.utils.CacheKeyUtils;
import org.apache.shenyu.plugin.rpc.context.handler.RpcContextPluginDataHandler;
import org.springframework.http.HttpHeaders;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

/**
 * RpcContextPlugin, transfer http headers to rpc context.
 */
public class RpcContextPlugin extends AbstractShenyuPlugin {

    @Override
    protected Mono<Void> doExecute(ServerWebExchange exchange, ShenyuPluginChain chain, SelectorData selector, RuleData rule) {
        RpcContextHandle rpcContextHandle = RpcContextPluginDataHandler.CACHED_HANDLE.get().obtainHandle(CacheKeyUtils.INST.getKey(rule));
        Map<String, String> rpcContextMap = new HashMap<>();
        Optional.ofNullable(rpcContextHandle.getAddRpcContext()).ifPresent(addRpcContextMap -> addRpcContextMap.forEach((k,v) -> rpcContextMap.put(k, v)));
        final HttpHeaders headers = exchange.getRequest().getHeaders();
        Optional.ofNullable(rpcContextHandle.getTransmitHeaderToRpcContext())
                .ifPresent(
                        transmitHeaderToRpcContext -> transmitHeaderToRpcContext.forEach(
                                (k, v) -> rpcContextMap.put(StringUtils.isBlank(v) ? k : v, headers.getFirst(k))
                        )
                );
        exchange.getAttributes().put("shenyuRpcContext", rpcContextMap);
        return chain.execute(exchange);
    }

    @Override
    public int getOrder() {
        return PluginEnum.RPC_CONTEXT.getCode();
    }

    @Override
    public String named() {
        return PluginEnum.RPC_CONTEXT.getName();
    }

    @Override
    public boolean skip(ServerWebExchange exchange) {
        return false;
    }

}
