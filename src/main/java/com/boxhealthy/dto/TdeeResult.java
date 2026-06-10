package com.boxhealthy.dto;

public class TdeeResult {
    private double bmr;
    private double tdee;
    private double loseWeightCalories;
    private double maintainCalories;
    private double gainMuscleCalories;
    private String recommendation;

    public TdeeResult(double bmr, double tdee) {
        this.bmr = bmr;
        this.tdee = tdee;
        this.loseWeightCalories = tdee - 500;
        this.maintainCalories = tdee;
        this.gainMuscleCalories = tdee + 300;
        this.recommendation = "AI gợi ý: ưu tiên bữa ăn giàu protein, nhiều rau xanh và tinh bột tốt để duy trì năng lượng ổn định.";
    }

    public double getBmr() { return bmr; }
    public double getTdee() { return tdee; }
    public double getLoseWeightCalories() { return loseWeightCalories; }
    public double getMaintainCalories() { return maintainCalories; }
    public double getGainMuscleCalories() { return gainMuscleCalories; }
    public String getRecommendation() { return recommendation; }
    public void setRecommendation(String recommendation) { this.recommendation = recommendation; }
}
