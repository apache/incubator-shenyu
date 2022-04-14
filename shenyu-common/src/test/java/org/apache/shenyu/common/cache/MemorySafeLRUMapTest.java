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

package org.apache.shenyu.common.cache;

import org.junit.Assert;
import org.junit.Test;

import java.util.Map;

/**
 * Test cases for MemorySafeLRUMapTest.
 */
public class MemorySafeLRUMapTest {
    @Test
    public void test() throws Exception {
        MemorySafeLRUMap<String, String> lru = new MemorySafeLRUMap<>(1 << 10);
        lru.put("1", "1");
        Assert.assertEquals(1, lru.size());
        lru.put("2", "2");
        lru.put("3", "3");
        Assert.assertEquals(1, lru.size());
        final Map.Entry<String, String> entry = lru.entrySet().iterator().next();
        final String key = entry.getKey();
        final String value = entry.getValue();
        Assert.assertEquals("3", key);
        Assert.assertEquals("3", value);
    }
}
