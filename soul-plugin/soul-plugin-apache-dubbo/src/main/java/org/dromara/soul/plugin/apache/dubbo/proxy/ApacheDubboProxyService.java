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

package org.dromara.soul.plugin.apache.dubbo.proxy;

import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.dubbo.common.constants.CommonConstants;
import org.apache.dubbo.config.ReferenceConfig;
import org.apache.dubbo.rpc.RpcContext;
import org.apache.dubbo.rpc.service.GenericException;
import org.apache.dubbo.rpc.service.GenericService;
import org.dromara.soul.common.constant.Constants;
import org.dromara.soul.common.dto.MetaData;
import org.dromara.soul.common.exception.SoulException;
import org.dromara.soul.common.utils.ParamCheckUtils;
import org.dromara.soul.plugin.apache.dubbo.cache.ApplicationConfigCache;
import org.dromara.soul.plugin.api.param.BodyParamResolveService;
import org.springframework.web.server.ServerWebExchange;

import java.util.Objects;

/**
 * dubbo proxy service is  use GenericService.
 *
 * @author xiaoyu(Myth)
 */
@Slf4j
public class ApacheDubboProxyService {

    private final BodyParamResolveService bodyParamResolveService;

    /**
     * Instantiates a new Dubbo proxy service.
     *
     * @param bodyParamResolveService the generic param resolve service
     */
    public ApacheDubboProxyService(final BodyParamResolveService bodyParamResolveService) {
        this.bodyParamResolveService = bodyParamResolveService;
    }

    /**
     * Generic invoker object.
     *
     * @param body     the body
     * @param metaData the meta data
     * @param exchange the exchange
     * @return the object
     * @throws SoulException the soul exception
     */
    public Object genericInvoker(final String body, final MetaData metaData, final ServerWebExchange exchange) throws SoulException {
        // issue(https://github.com/dromara/soul/issues/471), add dubbo tag route
        String dubboTagRouteFromHttpHeaders = exchange.getRequest().getHeaders().getFirst(Constants.DUBBO_TAG_ROUTE);
        if (StringUtils.isNotBlank(dubboTagRouteFromHttpHeaders)) {
            RpcContext.getContext().setAttachment(CommonConstants.TAG_KEY, dubboTagRouteFromHttpHeaders);
        }
        ReferenceConfig<GenericService> reference = ApplicationConfigCache.getInstance().get(metaData.getPath());
        if (Objects.isNull(reference) || StringUtils.isEmpty(reference.getInterface())) {
            ApplicationConfigCache.getInstance().invalidate(metaData.getPath());
            reference = ApplicationConfigCache.getInstance().initRef(metaData);
        }
        GenericService genericService = reference.get();
        try {
            Pair<String[], Object[]> pair;
            if (ParamCheckUtils.dubboBodyIsEmpty(body)) {
                pair = new ImmutablePair<>(new String[]{}, new Object[]{});
            } else {
                pair = bodyParamResolveService.buildParameter(body, metaData.getParameterTypes());
            }
            return genericService.$invoke(metaData.getMethodName(), pair.getLeft(), pair.getRight());
        } catch (GenericException e) {
            log.error("dubbo invoker have exception", e);
            throw new SoulException(e.getExceptionMessage());
        }
    }
}
