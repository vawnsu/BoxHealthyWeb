package com.boxhealthy.dto;

public class ProductIngredientFormDto {
    private Long nutritionItemId;
    private String note;
    private Integer weightGram;

    public Long getNutritionItemId() { return nutritionItemId; }
    public void setNutritionItemId(Long nutritionItemId) { this.nutritionItemId = nutritionItemId; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public Integer getWeightGram() { return weightGram; }
    public void setWeightGram(Integer weightGram) { this.weightGram = weightGram; }
}
