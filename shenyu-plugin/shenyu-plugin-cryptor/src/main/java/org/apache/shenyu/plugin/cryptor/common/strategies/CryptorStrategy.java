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

package org.apache.shenyu.plugin.cryptor.common.strategies;

/**
 * strategy.
 */
public interface CryptorStrategy {

    /**
     * strategy name.
     * @param name 策略名
     * @return 是否调过.
     */
    boolean skip(String name);

    /**
     * decrypt.
     * @param key key
     * @param encryptData encryptData
     * @return data
     * @throws Exception error
     */
    String decrypt(String key, String encryptData) throws Exception;

    /**
     * encrypt.
     * @param key key
     * @param data data
     * @return encryptData.
     * @throws Exception error
     */
    String encrypt(String key, String data) throws Exception;

}
