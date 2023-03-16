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

package org.apache.shenyu.admin.listener.apollo;

import org.apache.shenyu.admin.listener.AbstractDataChangedInit;
import org.apache.shenyu.common.constant.NacosPathConstants;
import org.apache.shenyu.register.client.server.apollo.ApolloClient;

import java.util.Objects;
import java.util.stream.Stream;

/**
 * the type apollo data change init
 *
 * @since 2.6.0
 */
public class ApolloDataChangedInit extends AbstractDataChangedInit {
    private final ApolloClient apolloClient;

    /**
     * Instantiates a new apollo data changed init.
     *
     * @param apolloClient the apollo client
     */
    public ApolloDataChangedInit(ApolloClient apolloClient) {
        this.apolloClient = apolloClient;
    }

    @Override
    protected boolean notExist() {
        return Stream.of(NacosPathConstants.PLUGIN_DATA_ID, NacosPathConstants.AUTH_DATA_ID, NacosPathConstants.META_DATA_ID).allMatch(
            this::dataIdNotExist);
    }

    private boolean dataIdNotExist(final String pluginDataId) {
        return Objects.isNull(apolloClient.getItemValue(pluginDataId));
    }
}
