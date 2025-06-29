--[[
  46765332 Senior Developer - Lorenzo Caldera
--]]
local s,id=GetID()

SET_JUNIOR_DEVELOPER = SET_JUNIOR_DEVELOPER or 0xffd

function s.initial_effect(c)
  --[[
    If you control a "Junior Developer" monster:
    You can Special Summon this card from your hand.
  --]]
  local e1 = Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(id,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,id)
  e1:SetCondition(s.e1cd)
  e1:SetTarget(s.e1tg)
  e1:SetOperation(s.e1op)
  c:RegisterEffect(e1)
end

s.listed_series = { SET_JUNIOR_DEVELOPER }
s.listed_card_types = { TYPE_MONSTER }

s.e1cd = function (e, tp, eg, ep, ev, re, r, rp)
  return Duel.IsExistingMatchingCard(
    function (c) return c:IsSetCard(SET_JUNIOR_DEVELOPER) end,
    tp, LOCATION_MZONE, 0, 1, nil)
end
s.e1tg = function (e, tp, eg, ep, ev, re, r, rp, chk, chkc)
  if chk == 0 then
    return Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
      and Duel.IsExistingMatchingCard(
        function (c) return Duel.IsPlayerCanSpecialSummon(tp, TYPE_SPSUMMON, POS_FACEUP, tp, e:GetHandler()) end,
        tp, LOCATION_HAND, 0, 1, nil)
  end
  Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g, 1, tp, 0)
end
s.e1op = function (e, tp, eg, ep, ev, re, r, rp)
  Duel.SpecialSummon(e:GetHandler(), SUMMON_TYPE_SPECIAL, tp, tp, false, false, POS_FACEUP)
end
