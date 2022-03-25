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

package org.apache.shenyu.admin.validation.validator;

import org.apache.shenyu.admin.exception.ResourceNotFoundException;
import org.apache.shenyu.admin.spring.SpringBeanUtils;
import org.apache.shenyu.admin.validation.ExistProvider;
import org.apache.shenyu.admin.validation.annotation.Existed;
import org.springframework.stereotype.Component;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.io.Serializable;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;

/**
 * ExistedValidator.
 */
@Component
public class ExistedValidator implements ConstraintValidator<Existed, Object> {
    
    /**
     * target annotation.
     */
    private Existed annotation;

    /**
     * provider cache.
     */
    private final Map<String, ExistProvider> providerCacheMap = new ConcurrentHashMap<>();
    
    @Override
    public void initialize(final Existed constraintAnnotation) {
        annotation = constraintAnnotation;
    }
    
    @Override
    public boolean isValid(final Object value, final ConstraintValidatorContext context) {
        if (Objects.isNull(annotation.provider())) {
            throw new ResourceNotFoundException("the validation ExistProvider is not found");
        }

        if (annotation.nullOfIgnore() && Objects.isNull(value)) {
            // null of ignore
            return true;
        }
        if (annotation.reverse()) {
            return !Boolean.TRUE.equals(checkValue(value));
        }
        return Boolean.TRUE.equals(checkValue(value));
    }
    
    private Boolean checkValue(final Object value) {
        Boolean result;
        try {
            Object bean = SpringBeanUtils.getInstance().getBean(annotation.provider());
            result = (Boolean) bean.getClass().getDeclaredMethod(annotation.providerMethonName(), Serializable.class).invoke(bean, value);
        } catch (Exception e) {
            throw new ResourceNotFoundException("the validation ExistProviderMethon invoked error");
        }
        return result;
    }
}
