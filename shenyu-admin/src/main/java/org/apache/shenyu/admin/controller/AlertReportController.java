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

package org.apache.shenyu.admin.controller;

import org.apache.shenyu.alert.model.AlertContentDTO;
import org.apache.shenyu.admin.model.result.ShenyuAdminResult;
import org.apache.shenyu.admin.service.AlertDispatchService;
import org.apache.shenyu.admin.utils.ShenyuResultMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

/**
 * Alert report Controller.
 */
@Validated
@RestController
@RequestMapping("/alert/report")
public class AlertReportController {

    @Autowired
    private AlertDispatchService alertDispatchService;

    /**
     * report new alert content.
     * @param alertContentDTO AlertContentDTO
     * @return row int
     */
    @PostMapping
    public ShenyuAdminResult reportAlert(@Valid @RequestBody final AlertContentDTO alertContentDTO) {
        alertDispatchService.dispatchAlert(alertContentDTO);
        return ShenyuAdminResult.success(ShenyuResultMessage.CREATE_SUCCESS);
    }
	
}
