## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----install------------------------------------------------------------------
# # install.packages("pak")
# pak::pak("sactyr/ibkrcp")

## ----session------------------------------------------------------------------
# library(ibkrcp)
# 
# # Verify the session is alive and authenticated — stops with an error if not
# ibkr_tickle()
# 
# # Check the raw authentication status
# ibkr_auth_status()

## ----reauth-------------------------------------------------------------------
# ibkr_reauthenticate()
# Sys.sleep(3)       # wait a few seconds for the session to restore
# ibkr_tickle()      # confirm it is back

## ----accounts-----------------------------------------------------------------
# # List all accounts associated with your login
# accounts <- ibkr_get_accounts()
# accounts
# #>   account_id      type currency           alias
# #> 1   U1234567 INDIVIDUAL      AUD Paper Trading
# 
# account_id <- accounts$account_id[1]
# 
# # High-level portfolio summary: cash, net liquidation, available funds
# ibkr_get_summary(account_id)
# 
# # Current open positions
# positions <- ibkr_get_positions(account_id)
# positions
# #>       conid symbol position mkt_price mkt_value avg_cost unrealised_pnl currency
# #> 1 123456789 VGS.AX      100    120.50     12050   115.00            550      AUD

## ----search-------------------------------------------------------------------
# contracts <- ibkr_search_contracts("VGS")
# contracts
# #>       conid symbol                                  company_name description company_header
# #> 1 123456789    VGS  Vanguard MSCI Index International Shares ETF    ASX:VGS    VGS - ASX
# 
# # Filter to ASX listing
# conid <- contracts$conid[grepl("ASX", contracts$company_header)]

## ----prices-------------------------------------------------------------------
# # Daily OHLCV bars for the past year
# prices <- ibkr_get_price_history(conid, period = "1y")
# head(prices)
# #>         date   open   high    low  close volume
# #> 1 2025-05-01 119.00 121.00 118.50 120.50  50000
# #> 2 2025-05-02 120.50 122.00 119.80 121.30  48000
# 
# # Available period strings: "1m", "3m", "6m", "1y", "2y", "3y", "5y"
# prices_3m <- ibkr_get_price_history(conid, period = "3m")

## ----schedule-----------------------------------------------------------------
# schedule <- ibkr_get_trading_schedule(symbol = "VGS", exchange = "ASX")
# head(schedule)
# #>         date is_trading                 sessions
# #> 1 2026-05-04       TRUE 100000-160000
# #> 2 2026-05-05      FALSE              <NA>
# 
# # Trading days only
# trading_days <- schedule[schedule$is_trading, "date"]

## ----place--------------------------------------------------------------------
# ibkr_place_order(
#   account_id = account_id,
#   conid      = conid,
#   side       = "BUY",
#   quantity   = 10
# )
# #> Order placed: BUY 10 shares (conid 123456789) for account U1234567

## ----orders-------------------------------------------------------------------
# orders <- ibkr_get_orders()
# orders
# #>   order_id     conid symbol side order_type quantity    status
# #> 1     1001 123456789 VGS.AX  BUY        MKT       10 Submitted

## ----cancel-------------------------------------------------------------------
# ibkr_cancel_order(account_id, order_id = "1001")
# #> Order 1001 cancelled for account U1234567

