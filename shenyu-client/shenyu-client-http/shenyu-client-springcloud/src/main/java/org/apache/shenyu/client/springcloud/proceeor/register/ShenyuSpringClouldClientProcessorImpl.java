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

package org.apache.shenyu.client.springcloud.proceeor.register;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.client.core.register.ApiBean;
import org.apache.shenyu.client.core.register.matcher.BaseAnnotationApiProcessor;
import org.apache.shenyu.client.springcloud.annotation.ShenyuSpringCloudClient;

import java.util.Objects;

/**
 * RequestMappingProcessorImpl.<br>
 * About support for {@link ShenyuSpringCloudClient} annotations
 *
 * @see ShenyuSpringCloudClient
 */
public class ShenyuSpringClouldClientProcessorImpl extends BaseAnnotationApiProcessor<ShenyuSpringCloudClient> {
    
    @Override
    public void process(final ApiBean apiBean, final ShenyuSpringCloudClient annotation) {
        apiBean.setBeanPath(annotation.path());
        apiBean.addProperties("desc", annotation.desc());
        if (StringUtils.isNotBlank(apiBean.getPropertiesValue("rule"))) {
            apiBean.addProperties("rule", annotation.ruleName());
        }
        apiBean.addProperties("value", annotation.value());
        apiBean.addProperties("enabled", Objects.toString(annotation.enabled()));
        apiBean.addProperties("registerMetaData", Objects.toString(annotation.registerMetaData()));
        if (!annotation.registerMetaData()) {
            apiBean.setStatus(ApiBean.Status.CAN_NO_BE_REGISTERED);
        } else {
            apiBean.setStatus(ApiBean.Status.REGISTRABLE_API);
        }
        // This annotation is on the support class, and all APIs will be registered
        for (ApiBean.ApiDefinition definition : apiBean.getApiDefinitions()) {
            definition.setStatus(apiBean.getStatus());
        }
    }
    
    @Override
    public void process(final ApiBean.ApiDefinition definition, final ShenyuSpringCloudClient annotation) {
        definition.setMethodPath(annotation.path());
        definition.addProperties("desc", annotation.desc());
        definition.addProperties("rule", annotation.ruleName());
        definition.addProperties("value", annotation.value());
        definition.addProperties("enabled", Objects.toString(annotation.enabled()));
        definition.addProperties("registerMetaData", Objects.toString(annotation.registerMetaData()));
        if (!annotation.registerMetaData()) {
            definition.setStatus(ApiBean.Status.CAN_NO_BE_REGISTERED);
        } else {
            definition.setStatus(ApiBean.Status.REGISTRABLE);
        }
    }
    
    @Override
    public Class<ShenyuSpringCloudClient> matchAnnotation() {
        return ShenyuSpringCloudClient.class;
    }
}
