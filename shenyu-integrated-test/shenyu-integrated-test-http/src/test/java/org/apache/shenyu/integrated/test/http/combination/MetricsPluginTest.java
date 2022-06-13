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

package org.apache.shenyu.integrated.test.http.combination;

import org.apache.shenyu.integratedtest.common.AbstractPluginDataInit;
import org.apache.shenyu.integratedtest.common.helper.HttpHelper;
import org.junit.jupiter.api.Test;
import org.apache.http.protocol.HTTP;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

import static org.junit.jupiter.api.Assertions.assertTrue;

public final class MetricsPluginTest extends AbstractPluginDataInit {

    @Test
    public void testPass() throws ExecutionException, InterruptedException {
        Map<String, Object> headers = new HashMap<>();
        headers.put("HTTP.CONN_DIRECTIVE", HTTP.CONN_CLOSE);
        Future<String> resp = this.getService().submit(() -> HttpHelper.INSTANCE.getHttpService("http://localhost:8090", headers, String.class));
        assertTrue(resp.get().contains("process_cpu_seconds_total"));
    }

}
