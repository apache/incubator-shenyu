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

package org.apache.shenyu.admin.mode.cluster;

import org.apache.shenyu.admin.config.properties.ClusterProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.integration.jdbc.lock.JdbcLockRegistry;

import java.time.Duration;
import java.util.concurrent.locks.Lock;

public class ShenyuClusterSelectMasterJdbcService implements ShenyuClusterSelectMasterService {
    
    private static final Logger LOG = LoggerFactory.getLogger(ShenyuClusterSelectMasterJdbcService.class);
    
    private static final String MASTER_LOCK_KEY = "shenyu:cluster:master";
    
    private final ClusterProperties clusterProperties;
    
    private final JdbcLockRegistry jdbcLockRegistry;
    
    private final Lock clusterMasterLock;
    
    private volatile boolean locked;
    
    public ShenyuClusterSelectMasterJdbcService(final ClusterProperties clusterProperties,
                                                final JdbcLockRegistry jdbcLockRegistry) {
        this.clusterProperties = clusterProperties;
        this.jdbcLockRegistry = jdbcLockRegistry;
        // set the lock duration
        this.jdbcLockRegistry.setIdleBetweenTries(Duration.ofSeconds(clusterProperties.getLockDuration()));
        this.clusterMasterLock = jdbcLockRegistry.obtain(MASTER_LOCK_KEY);
    }
    
    @Override
    public boolean selectMaster() {
        locked = clusterMasterLock.tryLock();
        return locked;
    }
    
    @Override
    public boolean renewMaster() {
        if (locked) {
            try {
                jdbcLockRegistry.renewLock(MASTER_LOCK_KEY);
            } catch (Exception e) {
                LOG.error("jdbc renew master error", e);
                releaseMaster();
            }
        }
        return locked;
    }
    
    @Override
    public boolean releaseMaster() {
        if (locked) {
            clusterMasterLock.unlock();
            locked = false;
        }
        return true;
    }
    
    @Override
    public boolean isMaster() {
        if (!clusterProperties.isEnabled()) {
            return true;
        }
        return locked;
    }
}
