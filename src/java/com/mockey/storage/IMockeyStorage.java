/*
 * This file is part of Mockey, a tool for testing application
 * interactions over HTTP, with a focus on testing web services,
 * specifically web applications that consume XML, JSON, and HTML.
 *
 * Copyright (C) 2009-2010  Authors:
 *
 * chad.lafontaine (chad.lafontaine AT gmail DOT com)
 * neil.cronin (neil AT rackle DOT com)
 * lorin.kobashigawa (lkb AT kgawa DOT com)
 * rob.meyer (rob AT bigdis DOT com)
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */
package com.mockey.storage;

import java.util.Collection;
import java.util.*;

import com.mockey.model.*;

/**
 * How Mockey stores itself.
 *
 * @author chad.lafontaine
 */
public interface IMockeyStorage {

    Long getTimeOfCreation();

    String getDefaultServicePlanId();

    void setDefaultServicePlanId(String v);

    Long getDefaultServicePlanIdAsLong();

    String getGlobalStateSystemFilterTag();

    void setGlobalStateSystemFilterTag(String tag);

    Boolean getReadOnlyMode();

    void setReadOnlyMode(Boolean transientState);

    void deleteEverything();

    List<TwistInfo> getTwistInfoList();

    TwistInfo getTwistInfoById(Long id);

    TwistInfo getTwistInfoByName(String name);

    TwistInfo saveOrUpdateTwistInfo(TwistInfo twistInfo);

    void deleteTwistInfo(TwistInfo twistInfo);

    Service getServiceById(Long serviceId);

    Service getServiceByUrl(String urlPath);

    List<Long> getServiceIds();

    List<Service> getServices();

    Service saveOrUpdateService(Service service);

    Service duplicateService(Service service);

    void deleteService(Service service);

    ServiceRef saveOrUpdateServiceRef(ServiceRef serviceRef);

    List<ServiceRef> getServiceRefs();

    ServicePlan getServicePlanById(Long servicePlanId);

    ServicePlan getServicePlanByName(String servicePlanName);

    List<ServicePlan> getServicePlans();

    ServicePlan saveOrUpdateServicePlan(ServicePlan servicePlan);

    /**
     * Goes through each ServicePlan and updates the Scenario Name associated to
     * the matching Service and Scenario IDs.
     *
     * @param serviceId       - needed to filter out only scenario updates associated with
     *                        the appropriate service.
     * @param oldScenarioName
     * @param newScenarioName
     */
    void updateServicePlansWithNewScenarioName(Long serviceId, String oldScenarioName, String newScenarioName);

    void updateServicePlansWithNewServiceName(String oldServiceName, String newServiceName);

    void deleteServicePlan(ServicePlan servicePlan);

    ScenarioRef getUniversalErrorScenarioRef();

    void setUniversalErrorScenarioRef(ScenarioRef scenario);

    Scenario getUniversalErrorScenario();

    Long getUniversalTwistInfoId();

    void setUniversalTwistInfoId(Long twistInfoId);

    ProxyServerModel getProxy();

    void setProxy(ProxyServerModel proxy);

    List<String> uniqueClientIPs();

    List<String> uniqueClientIPsForService(Long serviceId);

    List<FulfilledClientRequest> getFulfilledClientRequests();

    FulfilledClientRequest getFulfilledClientRequestsById(Long fulfilledClientRequestId);

    List<FulfilledClientRequest> getFulfilledClientRequestsFromIP(String ip);

    List<FulfilledClientRequest> getFulfilledClientRequestsForService(Long serviceId);

    List<FulfilledClientRequest> getFulfilledClientRequestsFromIPForService(String ip, Long serviceId);

    List<FulfilledClientRequest> getFulfilledClientRequest(Collection<String> filterArguments);

    void saveOrUpdateFulfilledClientRequest(FulfilledClientRequest requestResponseX);

    void deleteFulfilledClientRequests();

    void deleteFulfilledClientRequestById(Long fulfilledRequestID);

    void deleteFulfilledClientRequestsFromIP(Long ip);

    void deleteFulfilledClientRequestsForService(Long serviceId);

    void deleteFulfilledClientRequestsFromIPForService(String ip, Long serviceId);

    void deleteTagFromStore(String tag);

    Set<TagItem> getAllTagsFromStore();

    Service getServiceByName(String serviceName);

    void setServicePlan(ServicePlan servicePlan);
}
