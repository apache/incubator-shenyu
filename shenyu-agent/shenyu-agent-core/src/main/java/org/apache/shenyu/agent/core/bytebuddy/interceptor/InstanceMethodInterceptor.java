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
 *
 */

package org.apache.shenyu.agent.core.bytebuddy.interceptor;

import java.lang.reflect.Method;
import java.util.List;
import java.util.concurrent.Callable;

import org.apache.shenyu.agent.api.entity.MethodResult;
import org.apache.shenyu.agent.api.entity.TargetObject;
import org.apache.shenyu.agent.api.handler.InstanceMethodHandler;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.bytebuddy.implementation.bind.annotation.AllArguments;
import net.bytebuddy.implementation.bind.annotation.Origin;
import net.bytebuddy.implementation.bind.annotation.RuntimeType;
import net.bytebuddy.implementation.bind.annotation.SuperCall;
import net.bytebuddy.implementation.bind.annotation.This;

/**
 * The type Instance method interceptor.
 */
public class InstanceMethodInterceptor {
    
    private static final Logger LOG = LoggerFactory.getLogger(InstanceMethodInterceptor.class);
    
    private final List<InstanceMethodHandler> handlerList;
    
    /**
     * Instantiates a new Instance method interceptor.
     *
     * @param handlerList the handler list
     */
    public InstanceMethodInterceptor(final List<InstanceMethodHandler> handlerList) {
        this.handlerList = handlerList;
    }
    
    /**
     * Intercept object.
     *
     * @param target the target
     * @param method the method
     * @param args the args
     * @param callable the callable
     * @return the object
     * @throws Exception the exception
     */
    @RuntimeType
    public Object intercept(@This final Object target, @Origin final Method method, @AllArguments final Object[] args, @SuperCall final Callable<?> callable) throws Exception {

        TargetObject instance = (TargetObject) target;
        MethodResult methodResult = new MethodResult();
        for (InstanceMethodHandler handler : handlerList) {
            try {
                handler.before(instance, method, args, methodResult);
            } catch (final Throwable ex) {
                LOG.error("Failed to execute the before method of method {} in class {}", method.getName(), target.getClass(), ex);
            }
        }
        Object result;
        try {
            if (!methodResult.isReset()) {
                result = callable.call();
                methodResult.reset(result);
            } else {
                result = methodResult.getResult();
            }
        } catch (final Throwable ex) {
            for (InstanceMethodHandler handler : handlerList) {
                try {
                    handler.onThrowing(instance, method, args, ex);
                } catch (final Throwable handlerEx) {
                    LOG.error("Failed to execute the error handler of method {} in class {}", method.getName(), target.getClass(), handlerEx);
                }
            }
            throw ex;
        } finally {
            for (InstanceMethodHandler handler : handlerList) {
                try {
                    result = handler.after(instance, method, args, methodResult);
                } catch (final Throwable ex) {
                    LOG.error("Failed to execute the after method of method {} in class {}", method.getName(), target.getClass(), ex);
                }
            }
        }
        return result;
    }
}
