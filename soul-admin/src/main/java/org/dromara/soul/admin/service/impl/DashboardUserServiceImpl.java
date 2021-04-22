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

package org.dromara.soul.admin.service.impl;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.dromara.soul.admin.config.properties.SecretProperties;
import org.dromara.soul.admin.mapper.DataPermissionMapper;
import org.dromara.soul.admin.model.dto.DashboardUserDTO;
import org.dromara.soul.admin.model.dto.UserRoleDTO;
import org.dromara.soul.admin.model.entity.DashboardUserDO;
import org.dromara.soul.admin.model.entity.UserRoleDO;
import org.dromara.soul.admin.mapper.DashboardUserMapper;
import org.dromara.soul.admin.mapper.PermissionMapper;
import org.dromara.soul.admin.mapper.ResourceMapper;
import org.dromara.soul.admin.mapper.RoleMapper;
import org.dromara.soul.admin.mapper.UserRoleMapper;
import org.dromara.soul.admin.model.page.CommonPager;
import org.dromara.soul.admin.model.page.PageResultUtils;
import org.dromara.soul.admin.model.query.DashboardUserQuery;
import org.dromara.soul.admin.service.DashboardUserService;
import org.dromara.soul.admin.utils.AesUtils;
import org.dromara.soul.admin.model.vo.DashboardUserEditVO;
import org.dromara.soul.admin.model.vo.DashboardUserVO;
import org.dromara.soul.admin.model.vo.LoginDashboardUserVO;
import org.dromara.soul.admin.model.vo.RoleVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.ObjectUtils;

import javax.annotation.Resource;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * DashboardUserServiceImpl.
 *
 * @author jiangxiaofeng(Nicholas)
 */
@Service("dashboardUserService")
public class DashboardUserServiceImpl implements DashboardUserService {

    private static final String ADMIN_NAME = "admin";

    @Resource
    private SecretProperties secretProperties;

    private final DashboardUserMapper dashboardUserMapper;

    private final UserRoleMapper userRoleMapper;

    private final RoleMapper roleMapper;

    private final DataPermissionMapper dataPermissionMapper;

    @Autowired(required = false)
    public DashboardUserServiceImpl(final DashboardUserMapper dashboardUserMapper, final UserRoleMapper userRoleMapper,
                                    final RoleMapper roleMapper, final ResourceMapper resourceMapper, final PermissionMapper permissionMapper,
                                    final DataPermissionMapper dataPermissionMapper) {
        this.dashboardUserMapper = dashboardUserMapper;
        this.userRoleMapper = userRoleMapper;
        this.roleMapper = roleMapper;
        this.dataPermissionMapper = dataPermissionMapper;
    }

    /**
     * create or update dashboard user.
     *
     * @param dashboardUserDTO {@linkplain DashboardUserDTO}
     * @return rows
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public int createOrUpdate(final DashboardUserDTO dashboardUserDTO) {
        DashboardUserDO dashboardUserDO = DashboardUserDO.buildDashboardUserDO(dashboardUserDTO);
        if (StringUtils.isEmpty(dashboardUserDTO.getId())) {
            bindUserRole(dashboardUserDO.getId(), dashboardUserDTO.getRoles());
            return dashboardUserMapper.insertSelective(dashboardUserDO);
        }
        if (!ADMIN_NAME.equals(dashboardUserDTO.getUserName())) {
            userRoleMapper.deleteByUserId(dashboardUserDTO.getId());
        }
        if (CollectionUtils.isNotEmpty(dashboardUserDTO.getRoles())) {
            bindUserRole(dashboardUserDTO.getId(), dashboardUserDTO.getRoles());
        }
        return dashboardUserMapper.updateSelective(dashboardUserDO);
    }

    /**
     * delete dashboard users.
     *
     * @param ids primary key.
     * @return rows
     */
    @Override
    public int delete(final List<String> ids) {
        int dashboardUserCount = 0;
        for (String id : ids) {
            DashboardUserDO dashboardUserDO = dashboardUserMapper.selectById(id);
            if (!ObjectUtils.isEmpty(dashboardUserDO) && ADMIN_NAME.equals(dashboardUserDO.getUserName())) {
                continue;
            }
            dashboardUserCount += dashboardUserMapper.delete(id);
            userRoleMapper.deleteByUserId(id);
            dataPermissionMapper.deleteByUserId(id);
        }
        return dashboardUserCount;
    }

    /**
     * find dashboard user by id.
     *
     * @param id primary key..
     * @return {@linkplain DashboardUserVO}
     */
    @Override
    public DashboardUserEditVO findById(final String id) {
        return DashboardUserEditVO.buildDashboardUserEditVO(DashboardUserVO.buildDashboardUserVO(dashboardUserMapper.selectById(id)),
                userRoleMapper.findByUserId(id).stream()
                        .map(item -> RoleVO.buildRoleVO(roleMapper.selectById(item.getRoleId()))).filter(Objects::nonNull).collect(Collectors.toList()),
                roleMapper.selectAll().stream().map(RoleVO::buildRoleVO).collect(Collectors.toList()));
    }

    /**
     * find dashboard user by query.
     *
     * @param userName user name
     * @param password user password
     * @return {@linkplain DashboardUserVO}
     */
    @Override
    public DashboardUserVO findByQuery(final String userName, final String password) {
        return DashboardUserVO.buildDashboardUserVO(dashboardUserMapper.findByQuery(userName, password));
    }

    /**
     * find page of dashboard user by query.
     *
     * @param dashboardUserQuery {@linkplain DashboardUserQuery}
     * @return {@linkplain CommonPager}
     */
    @Override
    public CommonPager<DashboardUserVO> listByPage(final DashboardUserQuery dashboardUserQuery) {
        return PageResultUtils.result(dashboardUserQuery.getPageParameter(),
            () -> dashboardUserMapper.countByQuery(dashboardUserQuery),
            () -> dashboardUserMapper.selectByQuery(dashboardUserQuery)
                        .stream()
                        .map(DashboardUserVO::buildDashboardUserVO)
                        .collect(Collectors.toList()));
    }

    /**
     * To deal with the admin login.
     *
     * @param userName default username is admin
     * @param password admin password
     * @return {@linkplain LoginDashboardUserVO}
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public LoginDashboardUserVO login(final String userName, final String password) {
        String key = secretProperties.getKey();
        DashboardUserVO dashboardUserVO = findByQuery(userName, password);
        if (!ObjectUtils.isEmpty(dashboardUserVO)) {
            DashboardUserDTO dashboardUserDTO = DashboardUserDTO.builder()
                    .id(dashboardUserVO.getId())
                    .userName(dashboardUserVO.getUserName())
                    .password(AesUtils.aesEncryption(dashboardUserVO.getPassword(), key))
                    .role(dashboardUserVO.getRole())
                    .enabled(dashboardUserVO.getEnabled()).build();
            createOrUpdate(dashboardUserDTO);
        } else {
            dashboardUserVO = findByQuery(userName, AesUtils.aesEncryption(password, key));
        }
        return LoginDashboardUserVO.buildLoginDashboardUserVO(dashboardUserVO);
    }

    /**
     * bind user and role id.
     *
     * @param userId user id
     * @param roleIds role ids.
     */
    private void bindUserRole(final String userId, final List<String> roleIds) {
        roleIds.forEach(item -> userRoleMapper.insertSelective(UserRoleDO.buildUserRoleDO(UserRoleDTO.builder().userId(userId).roleId(item).build())));
    }
}
