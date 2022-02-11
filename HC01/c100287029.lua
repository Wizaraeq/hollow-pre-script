--冀望郷－バリアン－
function c100287029.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--CXyz, Number C and No. 101-107 cannot be targeted or destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c100287029.tg)
	e1:SetValue(aux.indoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--Attach opponent's monster as material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100287029,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100287029.ovcon)
	e3:SetTarget(c100287029.ovtg)
	e3:SetOperation(c100287029.ovop)
	c:RegisterEffect(e3)
end
function c100287029.tg(e,c)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local no=m.xyz_number
	return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or (c:IsSetCard(0x48) and no and no>=101 and no<=107))
end
function c100287029.ovcfilter(c,tp)
	local re=c:GetReasonEffect()
	return c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) and c:IsSummonPlayer(tp) and re and re:IsActiveType(TYPE_SPELL)
		and re:GetHandler():IsSetCard(0x95)
end
function c100287029.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100287029.ovcfilter,1,nil,tp)
end
function c100287029.ovfilter(c,e)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsCanBeEffectTarget(e)
end
function c100287029.ovtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local xyzg=eg:Filter(c100287029.ovcfilter,nil,tp):Filter(Card.IsCanBeEffectTarget,nil,e)
	local tg=Duel.GetMatchingGroup(c100287029.ovfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return #xyzg>0 and #tg>0 end
	local xyzc=xyzg:GetFirst()
	if #xyzg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		xyzc=xyzg:Select(tp,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local og=tg:Select(tp,1,1,nil)
	Duel.SetTargetCard(og+xyzc)
	e:SetLabelObject(xyzc)
end
function c100287029.ovop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local lc=tg:GetFirst()
	if lc==tc then lc=tg:GetNext() end
	if tc:IsRelateToEffect(e) and tc:IsControler(tp) and lc:IsRelateToEffect(e) and lc:IsControler(1-tp) and not lc:IsImmuneToEffect(e) then
		local og=lc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(tc,Group.FromCards(lc))
	end
end 