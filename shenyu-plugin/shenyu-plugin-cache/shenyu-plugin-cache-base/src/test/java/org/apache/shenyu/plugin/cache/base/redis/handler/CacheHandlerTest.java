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

package org.apache.shenyu.plugin.cache.base.redis.handler;

import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.enums.RedisModeEnum;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.plugin.cache.base.ICache;
import org.apache.shenyu.plugin.cache.base.config.CacheConfig;
import org.apache.shenyu.plugin.cache.base.enums.CacheEnum;
import org.apache.shenyu.plugin.cache.base.handler.CacheHandler;
import org.apache.shenyu.spi.ExtensionLoader;
import org.junit.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.junit.jupiter.MockitoExtension;

import java.nio.charset.StandardCharsets;
import java.util.Objects;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * CacheHandlerTest.
 */
@ExtendWith(MockitoExtension.class)
public class CacheHandlerTest {

    private ICache iCache;

    /**
     * set redis with db
     * @param db
     */
    private void prepareRedis(final Integer db) {

        final CacheConfig cacheConfig = new CacheConfig();
        cacheConfig.setCacheType(CacheEnum.REDIS.getName());
        cacheConfig.setUrl("shenyu-redis:6379");
        cacheConfig.setMode(RedisModeEnum.STANDALONE.getName());
        cacheConfig.setDatabase(db);
        cacheConfig.setMinIdle(1);
        final CacheHandler cacheHandler = new CacheHandler();
        final PluginData pluginData = new PluginData();
        pluginData.setConfig(GsonUtils.getInstance().toJson(cacheConfig));
        cacheHandler.handlerPlugin(pluginData);
        if (Objects.isNull(iCache)) {
            iCache = ExtensionLoader.getExtensionLoader(ICache.class).getJoin(cacheConfig.getCacheType());
        }

    }

    @Test
    public void prepareRedis() {

        prepareRedis(0);
        testCacheHandler();
        prepareRedis(1);
        prepareMemory();
    }

    @Test
    public void prepareMemory() {

        final CacheConfig cacheConfig = new CacheConfig();
        cacheConfig.setCacheType(CacheEnum.MEMORY.getName());
        final CacheHandler cacheHandler = new CacheHandler();
        final PluginData pluginData = new PluginData();
        pluginData.setConfig(GsonUtils.getInstance().toJson(cacheConfig));
        cacheHandler.handlerPlugin(pluginData);
        iCache = ExtensionLoader.getExtensionLoader(ICache.class).getJoin(cacheConfig.getCacheType());

        testCacheHandler();
    }

    private void testCacheHandler() {

        final String testKey = "testCacheHandler3";
        assertEquals(Boolean.FALSE, iCache.isExist(testKey));
        boolean flag = iCache.cacheData(testKey, testKey.getBytes(StandardCharsets.UTF_8), 100);
        assertEquals(Boolean.TRUE, flag);
        assertEquals(Boolean.TRUE, iCache.isExist(testKey));
        final byte[] value = iCache.getData(testKey);
        assert null != value;
        assertEquals(testKey, new String(value, StandardCharsets.UTF_8));

    }
}
