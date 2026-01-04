package vn.web.logistic.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
	    // Ánh xạ mọi yêu cầu bắt đầu bằng /uploads/ vào thư mục static/uploads/ trên ổ cứng
	    registry.addResourceHandler("/uploads/**")
	            .addResourceLocations("file:src/main/resources/static/uploads/");
	}
}