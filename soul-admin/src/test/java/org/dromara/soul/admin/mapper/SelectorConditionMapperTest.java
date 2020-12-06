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

package org.dromara.soul.admin.mapper;

import org.dromara.soul.admin.AbstractSpringIntegrationTest;
import org.dromara.soul.admin.entity.SelectorConditionDO;
import org.dromara.soul.admin.query.SelectorConditionQuery;
import org.dromara.soul.common.utils.UUIDUtils;
import org.junit.Before;
import org.junit.Test;

import javax.annotation.Resource;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

import static org.hamcrest.Matchers.greaterThan;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertThat;

/**
 * Test case for SelectorConditionMapper
 *
 * @author bigwillc
 */
public class SelectorConditionMapperTest extends AbstractSpringIntegrationTest {
    @Resource
    private SelectorConditionMapper selectorConditionMapper;

    private SelectorConditionDO record = buildSelectorConditionDO();

    @Before
    public void before() {
        int count = selectorConditionMapper.insert(record);
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testSelectById() {
        SelectorConditionDO result  = selectorConditionMapper.selectById(record.getId());
        assertNotNull(result);
    }

    @Test
    public void testSelectByQuery() {
        SelectorConditionQuery selectorConditionQuery = new SelectorConditionQuery(record.getSelectorId());
        List<SelectorConditionDO> result = selectorConditionMapper.selectByQuery(selectorConditionQuery);
        assertThat(result.size(), greaterThan(0));

        List<SelectorConditionDO> selectorWithoutSelectorId = selectorConditionMapper.selectByQuery(null);
        assertThat(selectorWithoutSelectorId.size(), greaterThan(0));
    }

    @Test
    public void testInsert() {
        SelectorConditionDO newRecord = buildSelectorConditionDO();
        int count = selectorConditionMapper.insert(newRecord);
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testInsertSelective() {
        SelectorConditionDO newRecord = buildSelectorConditionDO();
        int count = selectorConditionMapper.insertSelective(newRecord);
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testUpdate() {
        record.setParamValue("update_param_value");
        record.setDateUpdated(Timestamp.valueOf(LocalDateTime.now()));
        int count = selectorConditionMapper.update(record);
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testUpdateSelective() {
        record.setParamValue("update_param_value");
        record.setDateUpdated(Timestamp.valueOf(LocalDateTime.now()));
        int count = selectorConditionMapper.updateSelective(record);
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testDelete() {
        int count = selectorConditionMapper.delete(record.getId());
        assertThat(count, greaterThan(0));
    }

    @Test
    public void testDeleteByQuery() {
        SelectorConditionQuery selectorConditionQuery = new SelectorConditionQuery(record.getSelectorId());
        int count = selectorConditionMapper.deleteByQuery(selectorConditionQuery);
        assertThat(count, greaterThan(0));
    }

    private SelectorConditionDO buildSelectorConditionDO() {
        SelectorConditionDO selectorConditionDO = new SelectorConditionDO();
        selectorConditionDO.setId(UUIDUtils.getInstance().generateShortUuid());
        selectorConditionDO.setSelectorId(UUIDUtils.getInstance().generateShortUuid());
        selectorConditionDO.setParamType("post");
        selectorConditionDO.setOperator("=");
        selectorConditionDO.setParamName("test_param_Name");
        selectorConditionDO.setParamValue("test_param_value");
        Timestamp currentTime = Timestamp.valueOf(LocalDateTime.now());
        selectorConditionDO.setDateCreated(currentTime);
        selectorConditionDO.setDateUpdated(currentTime);
        return selectorConditionDO;
    }
}
