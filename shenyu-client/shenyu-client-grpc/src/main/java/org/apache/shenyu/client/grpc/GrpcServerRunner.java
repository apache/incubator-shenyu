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

package org.apache.shenyu.client.grpc;

import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.ServerServiceDefinition;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;

import java.io.IOException;
import java.util.List;

/**
 * Add grpc service and start grpc server.
 */
@Slf4j
public class GrpcServerRunner implements ApplicationRunner {

    private final GrpcClientBeanPostProcessor grpcClientBeanPostProcessor;

    public GrpcServerRunner(final GrpcClientBeanPostProcessor grpcClientBeanPostProcessor) {
        this.grpcClientBeanPostProcessor = grpcClientBeanPostProcessor;
    }

    @Override
    public void run(final ApplicationArguments args) {
        startGrpcServer();
    }

    private void startGrpcServer() {
        int port = grpcClientBeanPostProcessor.getPort();
        ServerBuilder<?> serverBuilder = ServerBuilder.forPort(port);

        List<ServerServiceDefinition> serviceDefinitions = grpcClientBeanPostProcessor.getServiceDefinitions();
        for (ServerServiceDefinition serviceDefinition : serviceDefinitions) {
            serverBuilder.addService(serviceDefinition);
            log.info("{} has been add to grpc server", serviceDefinition.getServiceDescriptor().getName());
        }

        try {
            Server server = serverBuilder.build().start();

            Runtime.getRuntime().addShutdownHook(new Thread(() -> {
                log.info("shutting down grpc server");
                server.shutdown();
                log.info("grpc server shut down");
            }));

            log.info("Grpc server started on port: {}", port);
        } catch (IOException e) {
            log.error("Grpc server failed to start", e);
        }
    }
}
