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

package org.apache.shenyu.admin.listener;

import org.apache.shenyu.common.dto.AppAuthData;
import org.apache.shenyu.common.dto.MetaData;
import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.dto.DiscoverySyncData;
import org.apache.shenyu.common.dto.ProxySelectorData;
import org.apache.shenyu.common.dto.RuleData;
import org.apache.shenyu.common.dto.SelectorData;
import org.apache.shenyu.common.enums.DataEventTypeEnum;

import java.util.List;

/**
 * Event listener, used to send notification of event changes,
 * used to support HTTP, websocket, zookeeper and other event notifications.
 * 数据变更事件的监听器
 */
public interface DataChangedListener {

    /**
     * invoke this method when AppAuth was received.
     * 应用认证数据变更
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onAppAuthChanged(List<AppAuthData> changed, DataEventTypeEnum eventType) {
    }

    /**
     * invoke this method when Plugin was received.
     * 插件数据变更
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onPluginChanged(List<PluginData> changed, DataEventTypeEnum eventType) {
    }

    /**
     * invoke this method when Selector was received.
     * 选择器数据变更
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onSelectorChanged(List<SelectorData> changed, DataEventTypeEnum eventType) {
    }

    /**
     * On meta data changed.
     * 元数据变更
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onMetaDataChanged(List<MetaData> changed, DataEventTypeEnum eventType) {

    }

    /**
     * invoke this method when Rule was received.
     * 规则数据变更
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onRuleChanged(List<RuleData> changed, DataEventTypeEnum eventType) {
    }

    /**
     * invoke this method when ProxySelector was changed.
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onProxySelectorChanged(List<ProxySelectorData> changed, DataEventTypeEnum eventType) {
    }

    /**
     * invoke this method when DiscoveryUpstream was changed.
     *
     * @param changed   the changed
     * @param eventType the event type
     */
    default void onDiscoveryUpstreamChanged(List<DiscoverySyncData> changed, DataEventTypeEnum eventType) {
    }

}
