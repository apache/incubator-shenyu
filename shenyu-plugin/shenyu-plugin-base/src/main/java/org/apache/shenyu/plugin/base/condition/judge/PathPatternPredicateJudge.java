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

package org.apache.shenyu.plugin.base.condition.judge;

import org.apache.shenyu.common.dto.ConditionData;
import org.apache.shenyu.common.enums.ParamTypeEnum;
import org.apache.shenyu.plugin.base.utils.PathMatchUtils;
import org.apache.shenyu.spi.Join;

import java.util.Objects;

/**
 * 1. it used {@linkplain org.springframework.web.util.pattern.PathPattern}
 * 2. not support '/api / ** /xxx'.
 * 3. better performance than {@linkplain org.springframework.util.AntPathMatcher}
 * Path pattern predicate judge.
 */
@Join
public class PathPatternPredicateJudge implements PredicateJudge {

    @Override
    public Boolean judge(final ConditionData conditionData, final String realData) {
        if (Objects.equals(ParamTypeEnum.URI.getName(), conditionData.getParamType())) {
            return PathMatchUtils.pathPattern(conditionData.getParamValue().trim(), realData);
        }
        return realData.contains(conditionData.getParamValue().trim());
    }
}
