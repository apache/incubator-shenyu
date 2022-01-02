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

package org.apache.shenyu.register.client.http;

import com.google.common.base.Splitter;
import com.google.common.collect.Lists;
import org.apache.shenyu.common.constant.Constants;
import org.apache.shenyu.common.exception.ShenyuException;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.register.client.api.ShenyuClientRegisterRepository;
import org.apache.shenyu.register.client.http.utils.RegisterUtils;
import org.apache.shenyu.register.common.config.ShenyuRegisterCenterConfig;
import org.apache.shenyu.register.common.dto.MetaDataRegisterDTO;
import org.apache.shenyu.register.common.dto.URIRegisterDTO;
import org.apache.shenyu.spi.Join;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.Assert;

import java.util.List;
import java.util.Optional;

/**
 * The type Http client register repository.
 */
@Join
public class HttpClientRegisterRepository implements ShenyuClientRegisterRepository {

    private String username;

    private String password;

    private List<String> serverList;

    private String accessToken;

    private static final Logger LOGGER = LoggerFactory.getLogger(RegisterUtils.class);

    public HttpClientRegisterRepository() {
    }

    public HttpClientRegisterRepository(final ShenyuRegisterCenterConfig config) {
        init(config);
    }

    @Override
    public void init(final ShenyuRegisterCenterConfig config) {
        this.username = config.getProps().getProperty(Constants.USER_NAME);
        this.password = config.getProps().getProperty(Constants.PASS_WORD);
        Assert.notNull(username, "please config the username on props !");
        Assert.notNull(password, "please config the password on props !");
        this.serverList = Lists.newArrayList(Splitter.on(",").split(config.getServerLists()));
        this.getAccessToken().ifPresent(V -> this.accessToken = String.valueOf(V));
        Assert.notNull(accessToken, "login error, please check the username and password !");
    }

    /**
     * Persist uri.
     *
     * @param registerDTO the register dto
     */
    @Override
    public void persistURI(final URIRegisterDTO registerDTO) {
        doRegister(registerDTO, Constants.URI_PATH, Constants.URI);
    }

    @Override
    public void persistInterface(final MetaDataRegisterDTO metadata) {
        doRegister(metadata, Constants.META_PATH, Constants.META_TYPE);
    }

    private Optional getAccessToken() {
        for (String server : serverList) {
            try {
                Optional login = RegisterUtils.doLogin(username, password, server.concat(Constants.LOGIN_PATH));
                return login;
            } catch (Exception e) {
                LOGGER.error("login admin url :{} is fail, will retry, ex is :{}", server, e);
            }
        }
        throw new ShenyuException("login admin some error, please check the admin");
    }

    private <T> void doRegister(final T t, final String path, final String type) {
        for (String server : serverList) {
            try {
                RegisterUtils.doRegister(GsonUtils.getInstance().toJson(t), server.concat(path), type, accessToken);
                return;
            } catch (Exception e) {
                LOGGER.error("register admin url :{} is fail, will retry, ex is :{}", server, e);
            }
        }
    }
}
