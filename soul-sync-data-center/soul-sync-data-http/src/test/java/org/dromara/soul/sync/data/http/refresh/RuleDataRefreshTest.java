package org.dromara.soul.sync.data.http.refresh;

import com.google.gson.JsonObject;
import org.dromara.soul.common.dto.ConfigData;
import org.dromara.soul.common.dto.PluginData;
import org.dromara.soul.common.dto.RuleData;
import org.dromara.soul.common.enums.ConfigGroupEnum;
import org.dromara.soul.common.utils.GsonUtils;
import org.dromara.soul.sync.data.api.PluginDataSubscriber;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Test cases for {@link RuleDataRefresh}
 *
 * @author davidliu
 */
public class RuleDataRefreshTest {
    
    private final RuleDataRefresh mockRuleDataRefresh = new RuleDataRefresh(new PluginDataSubscriber() {
        @Override
        public void onSubscribe(PluginData pluginData) {
        
        }
    });
    
    /**
     * test case for {@link RuleDataRefresh#convert(JsonObject)}
     */
    @Test
    public void testConvert() {
        JsonObject jsonObject = new JsonObject();
        JsonObject expectJsonObject = new JsonObject();
        jsonObject.add(ConfigGroupEnum.RULE.name(), expectJsonObject);
        Assert.assertEquals(expectJsonObject, mockRuleDataRefresh.convert(jsonObject));
    }
    
    /**
     * test case for {@link RuleDataRefresh#fromJson(JsonObject)}
     */
    @Test
    public void testFromJson() {
        ConfigData<RuleData> ruleDataConfigData = new ConfigData<>();
        RuleData ruleData = new RuleData();
        ruleDataConfigData.setData(Collections.singletonList(ruleData));
        JsonObject jsonObject = GsonUtils.getGson().fromJson(GsonUtils.getGson().toJson(ruleDataConfigData), JsonObject.class);
        Assert.assertEquals(ruleDataConfigData, mockRuleDataRefresh.fromJson(jsonObject));
    }
    
    /**
     * This case coverages the following method:
     * {@link RuleDataRefresh#cacheConfigData()}
     * {@link RuleDataRefresh#updateCacheIfNeed(ConfigData)}
     * <p>
     * For {@link RuleDataRefresh} inherits from {@link AbstractDataRefresh}, the {@link AbstractDataRefresh#GROUP_CACHE} was initialized when the class of
     * {@link AbstractDataRefresh} load, in two different test methods in this class, the the {@link AbstractDataRefresh#GROUP_CACHE} class only load once, so
     * the method which manipulate the {@link AbstractDataRefresh#GROUP_CACHE} invocation has aftereffects to the other methods
     */
    @Test
    public void testUpdateCacheIfNeed() {
        final RuleDataRefresh ruleDataRefresh = mockRuleDataRefresh;
        // first, expect getting null from cache
        Assert.assertNull(ruleDataRefresh.cacheConfigData());
        // update cache, then assert equals
        ConfigData<RuleData> expect = new ConfigData<>();
        Assert.assertTrue(ruleDataRefresh.updateCacheIfNeed(expect));
        Assert.assertEquals(expect, ruleDataRefresh.cacheConfigData());
    }
    
    /**
     * This case is only for {@link RuleDataRefresh} code coverage
     */
    @Test
    public void testRefresh() {
        final RuleDataRefresh ruleDataRefresh = mockRuleDataRefresh;
        RuleData ruleData = new RuleData();
        List<RuleData> ruleDataList = new ArrayList<>();
        ruleDataRefresh.refresh(ruleDataList);
        ruleDataList.add(ruleData);
        ruleDataRefresh.refresh(ruleDataList);
        
    }
}