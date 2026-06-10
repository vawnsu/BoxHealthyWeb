package com.boxhealthy.controller;

import com.boxhealthy.dto.TdeeRequest;
import com.boxhealthy.dto.TdeeResult;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class TdeeController {

    @GetMapping("/tdee")
    public String form(Model model) {
        TdeeRequest request = new TdeeRequest();
        request.setGender("MALE");
        request.setActivityLevel(1.2);
        request.setGoal("MAINTAIN");
        model.addAttribute("tdeeRequest", request);
        return "tdee-calculator";
    }

    @PostMapping("/tdee")
    public String calculate(@ModelAttribute TdeeRequest request, Model model) {
        double bmr = "FEMALE".equalsIgnoreCase(request.getGender())
                ? 10 * request.getWeight() + 6.25 * request.getHeight() - 5 * request.getAge() - 161
                : 10 * request.getWeight() + 6.25 * request.getHeight() - 5 * request.getAge() + 5;
        double tdee = bmr * request.getActivityLevel();
        TdeeResult result = new TdeeResult(Math.round(bmr), Math.round(tdee));
        if ("LOSE".equalsIgnoreCase(request.getGoal())) {
            result.setRecommendation("AI gợi ý: giảm khoảng 400-500 kcal/ngày, giữ protein cao và chọn các hộp cơm nhiều rau để no lâu.");
        } else if ("GAIN".equalsIgnoreCase(request.getGoal())) {
            result.setRecommendation("AI gợi ý: tăng nhẹ calories, bổ sung protein nạc và tinh bột tốt sau buổi tập để hỗ trợ tăng cơ.");
        }
        model.addAttribute("tdeeRequest", request);
        model.addAttribute("result", result);
        return "tdee-calculator";
    }
}
