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

package org.apache.shenyu.admin.service;

import org.apache.shenyu.admin.model.dto.ClusterMasterDTO;
import org.apache.shenyu.register.common.type.DataTypeParent;

/**
 * Cluster Master service.
 */
public interface ClusterMasterService {

    /**
     * set master.
     * @param masterHost master host
     * @param masterPort master host
     * @param contextPath master contextPath
     */
    void setMaster(String masterHost, String masterPort, String contextPath);

    /**
     * check master.
     * @param myHost my host
     * @param myPort my port
     * @param contextPath my contextPath
     * @return am i master
     */
    boolean isMaster(String myHost, String myPort, String contextPath);

    /**
     * check master.
     * @return is this node master
     */
    boolean isMaster();

    /**
     * remove master.
     */
    void removeMaster();

    /**
     * Get master.
     * @return ClusterMasterDTO
     */
    ClusterMasterDTO getMaster();

    /**
     * Get master url.
     * @return master url
     */
    String getMasterUrl();
    
    /**
     * Sync data.
     *
     * @param syncData sync data
     * @return sync result
     */
    String clusterDataSync(DataTypeParent syncData);
}