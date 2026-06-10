package com.boxhealthy.dto;

public class ProductIngredientDto {
    private String name;
    private String note;
    private Integer weightGram;
    private Integer calories;
    private Double protein;
    private Double carbs;
    private Double fat;

    public ProductIngredientDto(String name, String note, Integer weightGram, Integer calories,
                                Double protein, Double carbs, Double fat) {
        this.name = name;
        this.note = note;
        this.weightGram = weightGram;
        this.calories = calories;
        this.protein = protein;
        this.carbs = carbs;
        this.fat = fat;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Integer getWeightGram() { return weightGram; }
    public void setWeightGram(Integer weightGram) { this.weightGram = weightGram; }
    public Integer getCalories() { return calories; }
    public void setCalories(Integer calories) { this.calories = calories; }
    public Double getProtein() { return protein; }
    public void setProtein(Double protein) { this.protein = protein; }
    public Double getCarbs() { return carbs; }
    public void setCarbs(Double carbs) { this.carbs = carbs; }
    public Double getFat() { return fat; }
    public void setFat(Double fat) { this.fat = fat; }
}
