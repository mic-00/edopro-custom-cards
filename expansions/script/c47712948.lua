--[[
  47712948 Senior Developer - Federico Pollin
--]]
local s,id=GetID()

function s.initial_effect(c)
  --[[
    You can discard this card; add 1
    "SCAI ITEC" from your Deck or GY to your hand.
  --]]
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,id)
  e1:SetCost(Cost.Discard(function (c1) return c1:IsDiscardable() and c1:GetCardID() == c:GetCardID() end))
  e1:SetTarget(s.e1tg)
  e1:SetOperation(s.e1op)
  c:RegisterEffect(e1)
end

s.listed_names = { 20783281 }

s.e1ft = function (c)
  return c:IsCode(20783281)
end
s.e1tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.IsExistingMatchingCard(
        function (c) return Duel.IsPlayerCanSendtoHand(tp, c) and s.e1ft(c) end,
        tp, LOCATION_DECK, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_TOHAND + CATEGORY_SEARCH, nil, 1, tp, LOCATION_DECK)
end
s.e1op = function (e, tp, eg, ep, ev, re, r, rp)
  local g = Duel.GetMatchingGroup(s.e1ft, tp, LOCATION_DECK, 0, nil)
  if #g > 0 then
    Duel.SendtoHand(g:GetFirst(), nil, REASON_EFFECT)
  end
end
