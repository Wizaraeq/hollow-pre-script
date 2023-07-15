--ＦＡ－ダーク・ナイト・ランサー
function c101202041.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,3,c101202041.ovfilter,aux.Stringid(101202041,0),3,c101202041.xyzop)
	c:EnableReviveLimit()
	--Gains 300 ATK for each material attached to it and each card equipped to it
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c101202041.atkval)
	c:RegisterEffect(e1)
	--Add 1 "Xyz" card in your GY to your hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101202041,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101202041.thtg)
	e2:SetOperation(c101202041.thop)
	c:RegisterEffect(e2)
	--Attach 1 monster your opponent controls to this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101202041,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c101202041.atchcon)
	e3:SetTarget(c101202041.atchtg)
	e3:SetOperation(c101202041.atchop)
	c:RegisterEffect(e3)
end
function c101202041.ovfilter(c)
	return c:IsFaceup() and c:IsRank(5,6)
end
function c101202041.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,101202041)==0 end
	Duel.RegisterFlagEffect(tp,101202041,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c101202041.atkval(e,c)
	return (c:GetOverlayCount()+c:GetEquipCount())*300
end
function c101202041.thfilter(c)
	return c:IsSetCard(0x73) and c:IsAbleToHand()
end
function c101202041.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101202041.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101202041.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c101202041.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101202041.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c101202041.atchcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c101202041.atchfilter(c)
	return c:IsCanOverlay()
end
function c101202041.atchtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c101202041.atchfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c101202041.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
	local tc=Duel.SelectMatchingCard(tp,c101202041.atchfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end