#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mkdir -p /tmp/shenyu-e2e/oracle/schema
mkdir -p /tmp/shenyu-e2e/oracle/driver


wget -O /tmp/shenyu-e2e/oracle/driver/ojdbc8.jar \
https://download.oracle.com/otn-pub/otn_software/jdbc/ojdbc8.jar || \
  wget -O /tmp/shenyu-e2e/oracle/driver/ojdbc8.jar \
  https://download.oracle.com/otn-pub/otn_software/jdbc/ojdbc8.jar

cp db/init/oracle/schema.sql /tmp/shenyu-e2e/oracle/schema/schema.sql
