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

import org.apache.shenyu.common.dto.ConditionData;
import org.apache.shenyu.common.dto.convert.rule.impl.CacheRuleHandle;
import org.apache.shenyu.common.enums.OperatorEnum;
import org.apache.shenyu.common.enums.ParamTypeEnum;
import org.apache.shenyu.common.enums.PluginEnum;
import org.apache.shenyu.common.utils.JsonUtils;
import org.apache.shenyu.integratedtest.common.AbstractPluginDataInit;
import org.apache.shenyu.integratedtest.common.helper.HttpHelper;
import org.apache.shenyu.integratedtest.common.result.ResultBean;
import org.apache.shenyu.web.controller.LocalPluginController.RuleLocalData;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.is;
import static org.junit.jupiter.api.Assertions.assertEquals;

public final class CachePluginTest extends AbstractPluginDataInit {

    private static final String TEST_CACHE_PATH = "/http/test/cache";

    @BeforeEach
    public void setup() throws IOException {
        String pluginResult = initPlugin(PluginEnum.CACHE.getName(), "");
        assertThat(pluginResult, is("success"));
        String selectorAndRulesResult =
                initSelectorAndRules(PluginEnum.CACHE.getName(), "", buildSelectorConditionList(), buildRuleLocalDataList());
        assertThat(selectorAndRulesResult, is("success"));
    }

    @Test
    public void testPass() throws ExecutionException, InterruptedException {
        Future<ResultBean> resp0 = this.getService().submit(() -> HttpHelper.INSTANCE.getFromGateway(TEST_CACHE_PATH, ResultBean.class));
        Thread.sleep(2000);
        Future<ResultBean> resp1 = this.getService().submit(() -> HttpHelper.INSTANCE.getFromGateway(TEST_CACHE_PATH, ResultBean.class));
        assertEquals(resp0.get().getMsg(),resp1.get().getMsg());
    }

    private static List<ConditionData> buildSelectorConditionList() {
        ConditionData conditionData = new ConditionData();
        conditionData.setParamType(ParamTypeEnum.URI.getName());
        conditionData.setOperator(OperatorEnum.MATCH.getAlias());
        conditionData.setParamValue("/**");
        return Collections.singletonList(conditionData);
    }

    private static List<RuleLocalData> buildRuleLocalDataList() {
        final RuleLocalData ruleLocalData = new RuleLocalData();
        CacheRuleHandle cacheRuleHandle = new CacheRuleHandle();

        ConditionData conditionData = new ConditionData();
        conditionData.setParamType(ParamTypeEnum.URI.getName());
        conditionData.setOperator(OperatorEnum.MATCH.getAlias());
        conditionData.setParamName("testCache");
        conditionData.setParamValue("/**");
        ruleLocalData.setConditionDataList(Collections.singletonList(conditionData));
        ruleLocalData.setRuleHandler(JsonUtils.toJson(cacheRuleHandle));

        return Collections.singletonList(ruleLocalData);
    }

    @AfterEach
    public void clean() throws IOException {
        cleanPluginData(PluginEnum.CACHE.getName());
    }
}
