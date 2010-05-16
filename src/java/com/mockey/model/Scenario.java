/*
 * Copyright 2008-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mockey.model;

/**
 * A Scenario is a specific response from a Service.
 * 
 * @author chad.lafontaine
 */
public class Scenario implements PersistableItem {

	private Long id;
	private Long serviceId;
	private String scenarioName;
	private String requestMessage;
	private String responseMessage;
	private String matchStringArg = null;

	public String getScenarioName() {
		return scenarioName;
	}

	public void setScenarioName(String name) {
		this.scenarioName = name;
	}

	public String getRequestMessage() {
		return requestMessage;
	}

	public void setRequestMessage(String requestMessage) {
		this.requestMessage = requestMessage;
	}

	public String getResponseMessage() {
		return responseMessage;
	}

	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}

	public String getMatchStringArg() {
		return matchStringArg;
	}

	public void setMatchStringArg(String matchStringArg) {
		this.matchStringArg = matchStringArg;
	}

	public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("Scenario name:" + this.getScenarioName());
		sb.append("Match string:" + this.getMatchStringArg());
		sb.append("Request msg:" + this.getRequestMessage());
		sb.append("Response msg:" + this.getResponseMessage());
		return sb.toString();
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setServiceId(Long serviceId) {
		this.serviceId = serviceId;
	}

	public Long getServiceId() {
		return serviceId;
	}

	public boolean hasMatchArgument() {
		if (getMatchStringArg() != null
				&& getMatchStringArg().trim().length() > 0) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 
	 * @param otherScenario
	 * @return true if scenario name and scenario response message are equal
	 *         (case ignored), otherwise false.
	 */
	public boolean equals(Scenario otherScenario) {
		try {
			if (this.scenarioName.equalsIgnoreCase(otherScenario
					.getScenarioName())
					&& this.responseMessage.equalsIgnoreCase(otherScenario
							.getResponseMessage())) {
				return true;
			}
		} catch (Exception e) {

		}
		return false;
	}
}
