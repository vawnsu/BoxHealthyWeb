package com.boxhealthy.boxhealthyweb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.persistence.autoconfigure.EntityScan;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication(scanBasePackages = "com.boxhealthy")
@EntityScan("com.boxhealthy.entity")
@EnableJpaRepositories("com.boxhealthy.repository")
public class BoxHealthyWebApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(BoxHealthyWebApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(BoxHealthyWebApplication.class);
    }
}
