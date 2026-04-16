package com.cinema;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CinemaBackendApplication {

	public static void main(String[] args) {
		// Load file .env
		Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
		dotenv.entries().forEach(entry -> {
			System.setProperty(entry.getKey(), entry.getValue());
		});
		SpringApplication.run(CinemaBackendApplication.class, args);
	}
}
