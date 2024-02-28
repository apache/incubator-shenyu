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

package org.apache.shenyu.plugin.base.cache;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.shenyu.common.enums.RpcTypeEnum;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.Collections;
import java.util.List;

/**
 * The interface add data subscriber.
 */
public interface ExtendDataHandler<T> {
    
    /**
     * addHandlers.
     *
     * @param extendDatas extendDatas
     */
    void addHandlers(List<T> extendDatas);

    /**
     * removeHandlers.
     *
     * @param rpcTypeEnum rpcTypeEnum
     */
    void removeHandler(RpcTypeEnum rpcTypeEnum);

    /**
     * addHandlers.
     *
     * @param dataSubscribers dataSubscribers
     */
    default void putExtendDataHandler(List<?> dataSubscribers) {
        final Type[] genericInterfaces = this.getClass().getGenericInterfaces();
        if (genericInterfaces.length == 0 || CollectionUtils.isEmpty(dataSubscribers)) {
            return;
        }
        ParameterizedType parameterizedType = (ParameterizedType) genericInterfaces[1];
        Type[] actualTypeArguments = parameterizedType.getActualTypeArguments();
        if (actualTypeArguments.length == 0) {
            return;
        }
        final Class<?> actualTypeArgument = (Class<?>) actualTypeArguments[0];
        dataSubscribers.forEach(dataSubscriber -> {
            if (actualTypeArgument.isAssignableFrom(dataSubscriber.getClass())) {
                this.addHandlers(Collections.singletonList((T) dataSubscriber));
            }
        });
    }

    /**
     * removeHandlers.
     *
     * @param rpcTypeEnum rpcTypeEnum
     * @param dataSubscribers dataSubscribers
     */
    default void removeExtendDataHandler(RpcTypeEnum rpcTypeEnum, List<?> dataSubscribers) {
        if (CollectionUtils.isEmpty(dataSubscribers)) {
            return;
        }
        dataSubscribers.forEach(extendDataHandler -> {
            if (extendDataHandler instanceof ExtendDataHandler) {
                ((ExtendDataHandler<T>) extendDataHandler).removeHandler(rpcTypeEnum);
            }
        });
    }

    /**
     * Refresh.
     */
    default void refresh() {
    }
}