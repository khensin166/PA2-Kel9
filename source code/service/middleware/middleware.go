package middleware

import (
	"github.com/gofiber/fiber/v2"
	"github.com/khensin166/PA2-Kel9/utils"
)

var ActiveTokens = make(map[string]bool)

func Auth(ctx *fiber.Ctx) error {
	// membuat token
	token := ctx.Get("Authorization")
	if token == "" {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	//_, err := utils.VerifyToken(token)
	claims, err := utils.DecodeToken(token)
	if err != nil {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated err",
		})
	}

	// Cek apakah token ada dalam daftar token aktif
	if _, ok := ActiveTokens[token]; !ok {
		return ctx.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
			"message": "unauthenticated",
		})
	}

	ctx.Locals("staffInfo", claims)

	return ctx.Next()

}
