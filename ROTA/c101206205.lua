--リヴァーチュ・ドラゴン
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--Add 1 "Virtue Stream" from your Deck to your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Activate 1 of these effects
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.thfilter(c)
	return c:IsCode(101206208) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.thgyfilter(c)
	return c:IsRace(RACE_FISH+RACE_SEASERPENT+RACE_AQUA) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.xyztarget(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCanBeEffectTarget(e)
end
function s.overlayfilter(c)
	return c:GetOverlayCount()>0
end
function s.rescon(sg,e,tp)
	return sg:IsExists(s.overlayfilter,1,nil)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(s.thgyfilter,tp,LOCATION_GRAVE,0,1,nil)
	local g=Duel.GetMatchingGroup(s.xyztarget,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local b2=#g>=2 and g:CheckSubGroup(s.rescon,2,2,e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,2)},{b2,aux.Stringid(id,3)})
	e:SetLabel(op)
	if op==1 then
		Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	elseif op==2 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:SelectSubGroup(tp,s.rescon,false,2,2,e,tp)
		Duel.SetTargetCard(sg)
	end
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		--Add 1 Fish, Sea Serpent, or Aqua monster from your GY to your hand
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thgyfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if #g==2 and g:CheckSubGroup(s.rescon,2,2,e,tp) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
			local dtc=g:FilterSelect(tp,s.overlayfilter,1,1,nil):GetFirst()
			if dtc then
				g:RemoveCard(dtc)
				local atc=g:GetFirst()
				local at=dtc:GetOverlayGroup()
				if #at>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
					at=at:Select(tp,1,1,nil)
					Duel.Overlay(atc,at)
				end
			end
		end
	end
end