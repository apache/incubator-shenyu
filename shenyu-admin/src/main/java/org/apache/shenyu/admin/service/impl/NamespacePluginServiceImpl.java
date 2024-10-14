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

package org.apache.shenyu.admin.service.impl;

import com.google.common.collect.Lists;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.mapper.NamespacePluginRelMapper;
import org.apache.shenyu.admin.mapper.PluginMapper;
import org.apache.shenyu.admin.model.dto.PluginDTO;
import org.apache.shenyu.admin.model.dto.NamespacePluginDTO;
import org.apache.shenyu.admin.model.entity.NamespacePluginRelDO;
import org.apache.shenyu.admin.model.entity.PluginDO;
import org.apache.shenyu.admin.model.page.CommonPager;
import org.apache.shenyu.admin.model.page.PageResultUtils;
import org.apache.shenyu.admin.model.query.NamespacePluginQuery;
import org.apache.shenyu.admin.model.result.ConfigImportResult;
import org.apache.shenyu.admin.model.vo.NamespacePluginVO;
import org.apache.shenyu.admin.model.vo.PluginHandleVO;
import org.apache.shenyu.admin.model.vo.PluginSnapshotVO;
import org.apache.shenyu.admin.service.PluginHandleService;
import org.apache.shenyu.admin.service.NamespacePluginService;
import org.apache.shenyu.admin.service.publish.NamespacePluginEventPublisher;
import org.apache.shenyu.admin.transfer.PluginTransfer;
import org.apache.shenyu.admin.utils.ShenyuResultMessage;
import org.apache.shenyu.common.constant.AdminConstants;
import org.apache.shenyu.common.dto.PluginData;
import org.apache.shenyu.common.utils.ListUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class NamespacePluginServiceImpl implements NamespacePluginService {

    private final NamespacePluginRelMapper namespacePluginRelMapper;

    private final PluginHandleService pluginHandleService;

    private final NamespacePluginEventPublisher namespacePluginEventPublisher;

    private final PluginMapper pluginMapper;

    public NamespacePluginServiceImpl(final NamespacePluginRelMapper namespacePluginRelMapper,
                                      final PluginHandleService pluginHandleService,
                                      final NamespacePluginEventPublisher namespacePluginEventPublisher,
                                      final PluginMapper pluginMapper) {
        this.namespacePluginRelMapper = namespacePluginRelMapper;
        this.pluginHandleService = pluginHandleService;
        this.namespacePluginEventPublisher = namespacePluginEventPublisher;
        this.pluginMapper = pluginMapper;
    }

    @Override
    public NamespacePluginVO findById(final String id) {
        return namespacePluginRelMapper.selectById(id);
    }

    @Override
    public String create(final String namespaceId, final String pluginId) {
        NamespacePluginVO namespacePluginVO = namespacePluginRelMapper.selectByPluginIdAndNamespaceId(pluginId, namespaceId);
        if (!Objects.isNull(namespacePluginVO)) {
            return AdminConstants.NAMESPACE_PLUGIN_EXIST;
        }
        PluginDO pluginDO = pluginMapper.selectById(pluginId);
        NamespacePluginRelDO namespacePluginRelDO = NamespacePluginRelDO.buildNamespacePluginRelDO(pluginDO, namespaceId);
        namespacePluginRelMapper.insertSelective(namespacePluginRelDO);
        return ShenyuResultMessage.CREATE_SUCCESS;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String update(final NamespacePluginDTO namespacePluginDTO) {
        final NamespacePluginVO before = namespacePluginRelMapper.selectById(namespacePluginDTO.getId());
        NamespacePluginRelDO namespacePluginRelDO = NamespacePluginRelDO.buildNamespacePluginRelDO(namespacePluginDTO);
        if (namespacePluginRelMapper.updateSelective(namespacePluginRelDO) > 0) {
            final NamespacePluginVO now = namespacePluginRelMapper.selectById(namespacePluginDTO.getId());
            // publish update event.
            namespacePluginEventPublisher.onUpdated(now, before);
        }
        return ShenyuResultMessage.UPDATE_SUCCESS;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public String delete(final List<String> ids) {
        // select plugin id.
        List<NamespacePluginVO> namespacePluginVOS = this.namespacePluginRelMapper.selectByIds(ids);
        if (CollectionUtils.isEmpty(namespacePluginVOS)) {
            return AdminConstants.SYS_PLUGIN_ID_NOT_EXIST;
        }
        // delete plugins.
        if (this.namespacePluginRelMapper.deleteByIds(ListUtil.map(namespacePluginVOS, NamespacePluginVO::getId)) > 0) {
            // publish deleted event. synchronously delete and link data[selector,rule,condition,resource]
            namespacePluginEventPublisher.onDeleted(namespacePluginVOS);
        }
        return StringUtils.EMPTY;
    }

    @Override
    public CommonPager<NamespacePluginVO> listByPage(final NamespacePluginQuery namespacePluginQuery) {
        return PageResultUtils.result(namespacePluginQuery.getPageParameter(), () -> namespacePluginRelMapper.selectByQuery(namespacePluginQuery));
    }

    @Override
    public List<PluginData> listAll(final String namespaceId) {
        return ListUtil.map(namespacePluginRelMapper.selectAllByNamespaceId(namespaceId), PluginTransfer.INSTANCE::mapToData);
    }

    @Override
    public List<PluginData> listAll() {
        return ListUtil.map(namespacePluginRelMapper.selectAllByNamespaceId(), PluginTransfer.INSTANCE::mapToData);
    }

    @Override
    public List<NamespacePluginVO> listAllData(final String namespaceId) {
        Map<String, List<PluginHandleVO>> pluginHandleMap = pluginHandleService.listAllData()
                .stream()
                .collect(Collectors.groupingBy(PluginHandleVO::getPluginId));

        return namespacePluginRelMapper.selectAllByNamespaceId(namespaceId)
                .stream()
                .filter(Objects::nonNull)
                .peek(namespacePluginVO -> {
                    List<PluginHandleVO> pluginHandleList = Optional
                            .ofNullable(pluginHandleMap.get(namespacePluginVO.getPluginId()))
                            .orElse(Lists.newArrayList())
                            .stream()
                            // to make less volume of export data
                            .peek(x -> x.setDictOptions(null))
                            .collect(Collectors.toList());
                    namespacePluginVO.setPluginHandleList(pluginHandleList);
                }).collect(Collectors.toList());
    }

    @Override
    public String enabled(final List<String> ids, final Boolean enabled) {
        List<NamespacePluginVO> namespacePluginVOList = namespacePluginRelMapper.selectByIds(ids);
        if (CollectionUtils.isEmpty(namespacePluginVOList)) {
            return AdminConstants.SYS_PLUGIN_ID_NOT_EXIST;
        }
        namespacePluginVOList.forEach(pluginNsRelDO -> pluginNsRelDO.setEnabled(enabled));
        namespacePluginRelMapper.updateEnableByIdList(ids, enabled);
        // publish change event.
        if (CollectionUtils.isNotEmpty(namespacePluginVOList)) {
            namespacePluginEventPublisher.onEnabled(namespacePluginVOList);
        }
        return StringUtils.EMPTY;
    }

    @Override
    public List<PluginSnapshotVO> activePluginSnapshot() {
        //todo:Not yet implemented
        return null;
    }

    @Override
    public ConfigImportResult importData(final List<PluginDTO> pluginList) {
        return null;
    }
}
