--[[
  20783281 SCAI ITEC
--]]
local s,id=GetID()

SET_SCAI_ITEC        = SET_SCAI_ITEC or 0xffc

function s.initial_effect(c)
  --[[
    When this card is activated: You can add 1 "SCAI ITEC" monster
    from your Deck to your hand.
  --]]
  local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
  e1:SetCountLimit(1, {id, 0})
	c:RegisterEffect(e1)
end

s.listed_series = { SET_SCAI_ITEC }
s.listed_card_types = { TYPE_MONSTER }

s.e1ft = function (c)
  return c:IsSetCard(SET_SCAI_ITEC) and c:IsMonster()
end
s.e1tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(
        function (c) return Duel.IsPlayerCanSendtoHand(tp, c) and s.e1ft(c) end,
        tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetPossibleOperationInfo(0, CATEGORY_TOHAND + CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK)
end
s.e1op = function (e, tp, eg, ep, ev, re, r, rp)
  if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
    local g = Duel.SelectMatchingCard(tp, s.e1ft, tp, LOCATION_DECK, 0, 1, 1, nil)
    if #g > 0 then
      Duel.SendtoHand(g, nil, REASON_EFFECT)
    end
  end
end