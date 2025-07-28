package com.pocproject.awspocproject;


import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
// Use this code snippet in your app.
// If you need more information about configurations or implementing the sample
// code, visit the AWS docs:
// https://docs.aws.amazon.com/sdk-for-java/latest/developer-guide/home.html

// Make sure to import the following packages in your code
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

import javax.sql.DataSource;

@Configuration
public class AwsSecretManagerConfigurationClass {

    // @Value("${cloud.aws.credentials.access-key}")
    // private String accessKey;
    // @Value("${cloud.aws.credentials.secret-key}")
    // private String secretkey;

    private Gson gson = new Gson();

    @Bean
    public DataSource dataSource() {
        AwsSecrets secrets = getSecret();
        return DataSourceBuilder
                .create()
                //  .driverClassName("com.mysql.cj.jdbc.driver")
                .url("jdbc:" + secrets.getEngine() + "://" + secrets.getHost() + ":" + secrets.getPort() + "/deemodb")
                .username(secrets.getUsername())
                .password(secrets.getPassword())
                .build();
    }


    public AwsSecrets getSecret() {

        String secretName = "rds-secret";
        Region region = Region.of("us-east-1");

        AwsBasicCredentials awsCreds = AwsBasicCredentials.create(accessKey, secretkey);

        // Create a Secrets Manager client
        SecretsManagerClient client = SecretsManagerClient.builder()
                .region(region)
                // .credentialsProvider(StaticCredentialsProvider.create(awsCreds))
                .build();

        GetSecretValueRequest getSecretValueRequest = GetSecretValueRequest.builder()
                .secretId(secretName)
                .build();

        GetSecretValueResponse getSecretValueResponse;

        try {
            getSecretValueResponse = client.getSecretValue(getSecretValueRequest);
        } catch (Exception e) {
            throw e;
        }

        if (getSecretValueResponse.secretString() != null) {
            String secret = getSecretValueResponse.secretString();
            return gson.fromJson(secret, AwsSecrets.class);
        }

        return null;
    }
}
