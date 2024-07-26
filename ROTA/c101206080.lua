--火器の祝台
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x173)
	--special counter permit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_COUNTER_PERMIT+0x173)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.ctpermit)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.rccon1)
	e2:SetOperation(s.rcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.rccon2)
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x173,5,c) end
	c:AddCounter(0x173,5)
end
function s.ctpermit(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_CHAINING)
end
function s.defilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsSummonPlayer(tp) and (c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&TYPE_SPELL~=0 or c:GetSpecialSummonInfo(SUMMON_INFO_TYPE)&TYPE_TRAP~=0)
end
function s.rccon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.defilter,1,nil,tp)
end
function s.cfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function s.rccon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.sfilter(c)
	return c:IsSetCard(0x2bf) and c:IsSSetable()
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x173,1,REASON_EFFECT)
		if c:GetCounter(0x173)==0 then
			if Duel.Destroy(c,REASON_EFFECT)>0 and Duel.Recover(tp,4000,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.sfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):	GetFirst()
				if tc and Duel.SSet(tp,tc) then 
					Duel.BreakEffect()
					if Duel.GetLocationCount(tp,LOCATION_DECK)<=1 then
						Duel.Win(tp,0x23)
					end
				end
			end
		end
	end
end