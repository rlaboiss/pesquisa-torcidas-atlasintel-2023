logit <- function (x) binomial()$linkfun(x)
inv.logit <- function (x) binomial()$linkinv(x)

dat <- read.csv ("atlasintel-2023.csv")
dat.ok <- subset (dat, clube != "GOI")

fm <- lm (logit (dat.ok$imagem.negativa / 100) ~ logit (dat.ok$torcida / 100))
pred <- 100 * inv.logit (predict (fm))
antipathy <- dat.ok$imagem.negativa - pred

cor.test (logit (dat.ok$imagem.negativa / 100), logit (dat.ok$torcida / 100))

par (mar = c (5, 4, 0.1, 0.1))
plot (logit (dat$torcida / 100), logit (dat$imagem.negativa / 100), type = "n",
      bty = "n", xaxt = "n", yaxt = "n", xlab = "torcida (%)",
      ylab = "imagem negativa (%)",
      ylim = logit (c (min (pred), max (dat$imagem.negativa)) / 100))
text (logit (dat$torcida / 100), logit (dat$imagem.negativa / 100),
      labels = dat$clube)
x.ticks <- c (0.2, 0.5, 1, 2, 5, 10, 15, 20)
axis (1, las = 1, at = logit (x.ticks / 100), labels = x.ticks)
y.ticks <- seq (10, 35, by = 5)
axis (2, las = 1, at = logit (y.ticks / 100), labels = y.ticks)
dev.copy (png, file = "torcida-imagem-negativa.png",
          width = 400, height = 400)
dev.off ()
abline (fm, col = "#00000040", lwd = 3)
dev.copy (png, file = "torcida-imagem-negativa-regressao.png",
          width = 400, height = 400)
dev.off ()
cols <- ifelse (antipathy < 0, "green4", "red")
for (i in seq (1, nrow (dat.ok))) {
    lines (logit (rep (dat.ok$torcida [i], 2) / 100),
           logit (c (pred [i], dat.ok$imagem.negativa [i]) / 100),
           lwd = 3, col = cols [i])
}
text (logit (dat.ok$torcida / 100), logit (dat.ok$imagem.negativa / 100),
      labels = dat.ok$clube, col = cols)
dev.copy (png, file = "torcida-imagem-negativa-regressao-antipatia.png",
          width = 400, height = 400)
dev.off ()

idx <- sort (antipathy, index.return = TRUE)$ix
par (mar = c (5, 4, 0.1, 0.1))
plot (NA, NA, xlim = c (min (antipathy), max (antipathy)),
      ylim = c (1, nrow (df)), type = "n", xlab = "índice de antipatia",
      ylab = "", yaxt = "n", bty = "n")
abline (v = 0, col = "#ccccccff", lwd = 3)
for (i in seq (1, nrow (df)))
    lines (c (0, antipathy [idx [i]]), rep (i, 2), lwd = 15,
           col = cols [idx [i]])
axis (2, las = 1, at = seq (1, nrow (df)), labels = dat.ok$clube [idx],
      col = "#00000000")
dev.copy (png, file = "antipatia.png")
dev.off ()
