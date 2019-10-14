package com.mockey.model;

public class ApiOptionType {
    public final static ApiOptionType NUMBER = new ApiOptionType("number");
    public final static ApiOptionType STRING = new ApiOptionType("string");
    private String type = null;

    private ApiOptionType(String _type) {
        this.type = _type;
    }

    public boolean equals(ApiOptionType arg) {
        return arg != null && this.type.equals(arg.type);
    }

}
