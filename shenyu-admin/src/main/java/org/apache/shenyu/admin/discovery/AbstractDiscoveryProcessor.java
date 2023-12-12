package org.apache.shenyu.admin.discovery;

import org.apache.commons.lang3.StringUtils;
import org.apache.shenyu.admin.discovery.parse.CustomDiscoveryUpstreamParser;
import org.apache.shenyu.admin.listener.DataChangedEvent;
import org.apache.shenyu.admin.mapper.DiscoveryHandlerMapper;
import org.apache.shenyu.admin.mapper.DiscoveryUpstreamMapper;
import org.apache.shenyu.admin.mapper.ProxySelectorMapper;
import org.apache.shenyu.admin.model.dto.DiscoveryHandlerDTO;
import org.apache.shenyu.admin.model.dto.DiscoveryUpstreamDTO;
import org.apache.shenyu.admin.model.dto.ProxySelectorDTO;
import org.apache.shenyu.admin.model.entity.DiscoveryDO;
import org.apache.shenyu.admin.model.entity.DiscoveryHandlerDO;
import org.apache.shenyu.admin.model.entity.DiscoveryUpstreamDO;
import org.apache.shenyu.admin.model.entity.ProxySelectorDO;
import org.apache.shenyu.admin.transfer.DiscoveryTransfer;
import org.apache.shenyu.common.dto.DiscoverySyncData;
import org.apache.shenyu.common.dto.DiscoveryUpstreamData;
import org.apache.shenyu.common.enums.ConfigGroupEnum;
import org.apache.shenyu.common.enums.DataEventTypeEnum;
import org.apache.shenyu.common.utils.GsonUtils;
import org.apache.shenyu.common.utils.UUIDUtils;
import org.apache.shenyu.discovery.api.ShenyuDiscoveryService;
import org.apache.shenyu.discovery.api.config.DiscoveryConfig;
import org.apache.shenyu.discovery.api.listener.DataChangedEventListener;
import org.apache.shenyu.spi.ExtensionLoader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;
import java.util.Properties;
import java.util.HashSet;
import java.util.Collections;

public abstract class AbstractDiscoveryProcessor implements DiscoveryProcessor, ApplicationEventPublisherAware {

    protected static final String DEFAULT_LISTENER_NODE = "/shenyu/discovery";

    protected static final Logger LOG = LoggerFactory.getLogger(DefaultDiscoveryProcessor.class);

    protected final Map<String, ShenyuDiscoveryService> discoveryServiceCache;

    protected final Map<String, Set<String>> dataChangedEventListenerCache;

    protected ApplicationEventPublisher eventPublisher;

    protected final DiscoveryUpstreamMapper discoveryUpstreamMapper;

    protected final DiscoveryHandlerMapper discoveryHandlerMapper;

    protected final ProxySelectorMapper proxySelectorMapper;

    /**
     * DefaultDiscoveryProcessor.
     *
     * @param discoveryUpstreamMapper discoveryUpstreamMapper
     */
    public AbstractDiscoveryProcessor(final DiscoveryUpstreamMapper discoveryUpstreamMapper,
                                      final DiscoveryHandlerMapper discoveryHandlerMapper,
                                      final ProxySelectorMapper proxySelectorMapper) {
        this.discoveryUpstreamMapper = discoveryUpstreamMapper;
        this.discoveryServiceCache = new ConcurrentHashMap<>();
        this.discoveryHandlerMapper = discoveryHandlerMapper;
        this.dataChangedEventListenerCache = new ConcurrentHashMap<>();
        this.proxySelectorMapper = proxySelectorMapper;
    }

    @Override
    public void createDiscovery(final DiscoveryDO discoveryDO) {
        if (discoveryServiceCache.containsKey(discoveryDO.getId())) {
            LOG.info("shenyu DiscoveryProcessor {} discovery has been init", discoveryDO.getId());
            return;
        }
        String type = discoveryDO.getType();
        String props = discoveryDO.getProps();
        Properties properties = GsonUtils.getGson().fromJson(props, Properties.class);
        DiscoveryConfig discoveryConfig = new DiscoveryConfig();
        discoveryConfig.setType(type);
        discoveryConfig.setProps(properties);
        discoveryConfig.setServerList(discoveryDO.getServerList());
        ShenyuDiscoveryService discoveryService = ExtensionLoader.getExtensionLoader(ShenyuDiscoveryService.class).getJoin(type);
        discoveryService.init(discoveryConfig);
        discoveryServiceCache.put(discoveryDO.getId(), discoveryService);
        dataChangedEventListenerCache.put(discoveryDO.getId(), new HashSet<>());
    }


    /**
     * removeDiscovery by ShenyuDiscoveryService#shutdown .
     *
     * @param discoveryDO discoveryDO
     */
    @Override
    public void removeDiscovery(final DiscoveryDO discoveryDO) {
        ShenyuDiscoveryService shenyuDiscoveryService = discoveryServiceCache.get(discoveryDO.getId());
        shenyuDiscoveryService.shutdown();
        LOG.info("shenyu discovery shutdown [{}] discovery", discoveryDO.getName());
    }

    /**
     * removeProxySelector.
     *
     * @param proxySelectorDTO proxySelectorDTO
     */
    @Override
    public void removeProxySelector(final DiscoveryHandlerDTO discoveryHandlerDTO, final ProxySelectorDTO proxySelectorDTO) {
        ShenyuDiscoveryService shenyuDiscoveryService = discoveryServiceCache.get(discoveryHandlerDTO.getDiscoveryId());
        String key = buildProxySelectorKey(discoveryHandlerDTO.getListenerNode());
        Set<String> cacheKey = dataChangedEventListenerCache.get(discoveryHandlerDTO.getDiscoveryId());
        cacheKey.remove(key);
        shenyuDiscoveryService.unwatch(key);
        DataChangedEvent dataChangedEvent = new DataChangedEvent(ConfigGroupEnum.PROXY_SELECTOR, DataEventTypeEnum.DELETE,
                Collections.singletonList(DiscoveryTransfer.INSTANCE.mapToData(proxySelectorDTO)));
        eventPublisher.publishEvent(dataChangedEvent);
    }

    @Override
    public void changeUpstream(final ProxySelectorDTO proxySelectorDTO, final List<DiscoveryUpstreamDTO> upstreamDTOS) {
        DiscoverySyncData discoverySyncData = new DiscoverySyncData();
        discoverySyncData.setPluginName(proxySelectorDTO.getPluginName());
        discoverySyncData.setSelectorId(proxySelectorDTO.getId());
        discoverySyncData.setSelectorName(proxySelectorDTO.getName());
        List<DiscoveryUpstreamData> upstreamDataList = upstreamDTOS.stream().map(DiscoveryTransfer.INSTANCE::mapToData).collect(Collectors.toList());
        discoverySyncData.setUpstreamDataList(upstreamDataList);
        DataChangedEvent dataChangedEvent = new DataChangedEvent(ConfigGroupEnum.DISCOVER_UPSTREAM, DataEventTypeEnum.UPDATE, Collections.singletonList(discoverySyncData));
        eventPublisher.publishEvent(dataChangedEvent);
    }

    @Override
    public void fetchAll(final String discoveryHandlerId) {
        DiscoveryHandlerDO discoveryHandlerDO = discoveryHandlerMapper.selectById(discoveryHandlerId);
        String discoveryId = discoveryHandlerDO.getDiscoveryId();
        if (discoveryServiceCache.containsKey(discoveryId)) {
            ShenyuDiscoveryService shenyuDiscoveryService = discoveryServiceCache.get(discoveryId);
            List<String> childData = shenyuDiscoveryService.getRegisterData(buildProxySelectorKey(discoveryHandlerDO.getListenerNode()));
            List<DiscoveryUpstreamData> discoveryUpstreamDataList = childData.stream().map(s -> GsonUtils.getGson().fromJson(s, DiscoveryUpstreamData.class))
                    .collect(Collectors.toList());
            Set<String> urlList = discoveryUpstreamDataList.stream().map(DiscoveryUpstreamData::getUrl).collect(Collectors.toSet());
            List<DiscoveryUpstreamDO> discoveryUpstreamDOS = discoveryUpstreamMapper.selectByDiscoveryHandlerId(discoveryHandlerId);
            Set<String> dbUrlList = discoveryUpstreamDOS.stream().map(DiscoveryUpstreamDO::getUrl).collect(Collectors.toSet());
            List<String> deleteIds = new ArrayList<>();
            for (DiscoveryUpstreamDO discoveryUpstreamDO : discoveryUpstreamDOS) {
                if (!urlList.contains(discoveryUpstreamDO.getUrl())) {
                    deleteIds.add(discoveryUpstreamDO.getId());
                }
            }
            if (!deleteIds.isEmpty()) {
                discoveryUpstreamMapper.deleteByIds(deleteIds);
            }
            for (DiscoveryUpstreamData currDiscoveryUpstreamDate : discoveryUpstreamDataList) {
                if (!dbUrlList.contains(currDiscoveryUpstreamDate.getUrl())) {
                    DiscoveryUpstreamDO discoveryUpstreamDO = DiscoveryTransfer.INSTANCE.mapToDo(currDiscoveryUpstreamDate);
                    discoveryUpstreamDO.setId(UUIDUtils.getInstance().generateShortUuid());
                    discoveryUpstreamDO.setDiscoveryHandlerId(discoveryHandlerId);
                    discoveryUpstreamDO.setDateCreated(new Timestamp(System.currentTimeMillis()));
                    discoveryUpstreamDO.setDateUpdated(new Timestamp(System.currentTimeMillis()));
                    discoveryUpstreamMapper.insert(discoveryUpstreamDO);
                }
            }

            ProxySelectorDO proxySelectorDO = proxySelectorMapper.selectByHandlerId(discoveryHandlerId);
            DiscoverySyncData discoverySyncData = new DiscoverySyncData();
            discoverySyncData.setSelectorId(proxySelectorDO.getId());
            discoverySyncData.setSelectorName(proxySelectorDO.getName());
            discoverySyncData.setPluginName(proxySelectorDO.getPluginName());
            discoverySyncData.setUpstreamDataList(discoveryUpstreamDataList);
            DataChangedEvent dataChangedEvent = new DataChangedEvent(ConfigGroupEnum.DISCOVER_UPSTREAM, DataEventTypeEnum.UPDATE, Collections.singletonList(discoverySyncData));
            eventPublisher.publishEvent(dataChangedEvent);
        }
    }

    /**
     * buildProxySelectorKey.
     *
     * @param listenerNode listenerNode
     * @return key
     */
    protected String buildProxySelectorKey(final String listenerNode) {
        return StringUtils.isNotBlank(listenerNode) ? listenerNode : DEFAULT_LISTENER_NODE;
    }

    /**
     * getDiscoveryDataChangedEventListener.
     *
     * @param discoveryHandlerDTO discoveryHandlerDTO
     * @param proxySelectorDTO    proxySelectorDTO
     * @return DataChangedEventListener
     */
    public DataChangedEventListener getDiscoveryDataChangedEventListener(final DiscoveryHandlerDTO discoveryHandlerDTO, final ProxySelectorDTO proxySelectorDTO) {
        final Map<String, String> customMap = GsonUtils.getInstance().toObjectMap(discoveryHandlerDTO.getHandler(), String.class);
        DiscoverySyncData discoverySyncData = new DiscoverySyncData();
        discoverySyncData.setPluginName(proxySelectorDTO.getPluginName());
        discoverySyncData.setSelectorName(proxySelectorDTO.getName());
        discoverySyncData.setSelectorId(proxySelectorDTO.getId());
        return new DiscoveryDataChangedEventSyncListener(eventPublisher, discoveryUpstreamMapper,
                new CustomDiscoveryUpstreamParser(customMap), discoveryHandlerDTO.getId(), discoverySyncData);
    }

    @Override
    public void setApplicationEventPublisher(final ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }


}
