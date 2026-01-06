package vn.web.logistic.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Dev-only helper to backfill data when entity column mappings changed.
 *
 * Why: some tables may end up with both camelCase and snake_case columns after
 * changing @Column mappings. Existing rows might have values only in the old
 * columns, leading to "missing data" symptoms in the app.
 */
@Component
@Profile("dev")
public class DevDatabaseBackfillRunner implements ApplicationRunner {

    private static final Logger logger = LoggerFactory.getLogger(DevDatabaseBackfillRunner.class);

    private final JdbcTemplate jdbcTemplate;

    public DevDatabaseBackfillRunner(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @Override
    public void run(ApplicationArguments args) {
        // USERS: backfill snake_case columns from legacy camelCase columns if both exist.
        backfillIfBothColumnsExist("USERS", "created_at", "createdAt");
        backfillIfBothColumnsExist("USERS", "updated_at", "updatedAt");
        backfillIfBothColumnsExist("USERS", "last_login_at", "lastLoginAt");

        // password_hash should remain BCrypt; only copy if legacy column already looks BCrypt and new column is empty
        if (columnExists("USERS", "password_hash") && columnExists("USERS", "passwordHash")) {
            int updated = jdbcTemplate.update(
                    "UPDATE USERS " +
                    "SET password_hash = passwordHash " +
                    "WHERE (password_hash IS NULL OR password_hash = '') " +
                    "  AND passwordHash LIKE '$2%'");
            if (updated > 0) {
                logger.warn("Dev DB backfill: updated {} USERS.password_hash from USERS.passwordHash", updated);
            }
        }
    }

    private void backfillIfBothColumnsExist(String table, String targetColumn, String sourceColumn) {
        if (!columnExists(table, targetColumn) || !columnExists(table, sourceColumn)) {
            return;
        }

        int updated = jdbcTemplate.update(
                "UPDATE `" + table + "` " +
                "SET `" + targetColumn + "` = `" + sourceColumn + "` " +
                "WHERE `" + targetColumn + "` IS NULL AND `" + sourceColumn + "` IS NOT NULL");

        if (updated > 0) {
            logger.warn("Dev DB backfill: updated {} {}.{} from {}", updated, table, targetColumn, sourceColumn);
        }
    }

    private boolean columnExists(String table, String column) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM information_schema.COLUMNS " +
                "WHERE TABLE_SCHEMA = DATABASE() " +
                "  AND LOWER(TABLE_NAME) = LOWER(?) " +
                "  AND LOWER(COLUMN_NAME) = LOWER(?)",
                Integer.class,
                table,
                column);
        return count != null && count > 0;
    }
}
