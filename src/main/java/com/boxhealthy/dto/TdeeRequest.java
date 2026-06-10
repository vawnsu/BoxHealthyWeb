package com.boxhealthy.dto;

public class TdeeRequest {
    private String gender;
    private Integer age;
    private Double height;
    private Double weight;
    private Double activityLevel;
    private String goal;

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }
    public Double getHeight() { return height; }
    public void setHeight(Double height) { this.height = height; }
    public Double getWeight() { return weight; }
    public void setWeight(Double weight) { this.weight = weight; }
    public Double getActivityLevel() { return activityLevel; }
    public void setActivityLevel(Double activityLevel) { this.activityLevel = activityLevel; }
    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }
}
